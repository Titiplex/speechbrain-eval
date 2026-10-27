"""Run with: python -m unittest discover -s tests -p test_protocol.py"""
import csv
import json
import shutil
import tempfile
import unittest
import wave
from pathlib import Path
from html.parser import HTMLParser

ROOT=Path(__file__).resolve().parents[1]

class Inputs(HTMLParser):
    def __init__(self):
        super().__init__();self.inputs=[];self.selects=[]
    def handle_starttag(self,tag,attrs):
        attrs=dict(attrs)
        if tag=='input':self.inputs.append(attrs)
        if tag=='select':self.selects.append(attrs)

class ProtocolTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp=tempfile.TemporaryDirectory();cls.instance=Path(cls.tmp.name)/'demo'
        shutil.copytree(
            ROOT / "demo",
            cls.instance,
            ignore=shutil.ignore_patterns(".tmp", "flexeval.db*"),
        )
        for file in (cls.instance/'systems').glob('*.csv'):
            with file.open(encoding='utf-8') as f:
                for row in csv.DictReader(f):
                    path=cls.instance/'systems'/row['sound'];path.parent.mkdir(parents=True,exist_ok=True)
                    if not path.exists():
                        with wave.open(str(path),'wb') as wav:
                            wav.setparams((1,2,8000,0,'NONE','not compressed'));wav.writeframes(b'\0\0'*800)
        from flexeval import create_app
        cls.app=create_app(str(cls.instance),'http://localhost');cls.app.testing=True
    @classmethod
    def tearDownClass(cls):cls.tmp.cleanup()
    def page(self, response, expected):
        self.assertEqual(
            response.status_code,
            200,
            f"Réponse inattendue : HTTP {response.status_code}, "
            f"Location={response.headers.get('Location')!r}",
        )
        body = response.data.decode("utf-8")
        self.assertNotIn("HTTP status code:", body)
        self.assertIn(expected, body)
        return body
    def test_statistics(self):
        from flexeval.mods.stats.src.analysis import numeric,paired,categorical,quality
        def row(user,a,b,**kw):return dict(user_pseudo=user,MOS_score_sys1=a,MOS_score_sys2=b,**kw)
        data=[row('p',5,3),row('q',3,2)]
        self.assertEqual(numeric(data,'MOS_score_sys1')['participants'],2)
        self.assertEqual(paired(data,['MOS_score_sys1','MOS_score_sys2'])['difference'],1.5)
        self.assertEqual(numeric(data+[row('x','nan','bad')],'MOS_score_sys1')['invalid'],1)
        self.assertEqual(numeric([row('p',5,3,protocol_role='repeat')],'MOS_score_sys1')['n'],0)
        counts=categorical([dict(user_pseudo='p',ChoiceBetween_sys1_sys2=v) for v in ['sys1','tie','sys2']],'ab')
        self.assertEqual(counts['shared_ties'],.5);self.assertEqual(counts['decisive_sys1'],.5)
        self.assertIsNone(numeric([row('p',1,1)],'MOS_score_sys1')['ci'])
    def test_whole_native_campaign(self):
        from flexeval.mods.test.src import TestManager
        from flexeval.database import db
        from sqlalchemy import Table,MetaData
        c=self.app.test_client();c.get('/stage/page:user/accueil/');c.post('/legal_terms/ok',data={'demo_agreement':'yes'})
        config=json.loads((self.instance/'structure.json').read_text())
        c.post('/admin/admin_panel/login',data={'admin_password':config['admin']['entrypoint']['password']})
        for report in config['admin']['mods'][1]['reports']:
            self.page(c.get('/admin/stats/?report='+report),'/admin/stats/') if report!='controles' else self.page(c.get('/admin/stats/?report='+report),'Contrôles')
        for stage,data in [('listening_conditions',dict(equipment='headphones',environment='quiet',volume_ready='yes')),
                           ('comprehension',dict(criterion='raccord',attempts='2',first_choice='meaning'))]:
            self.page(c.get('/stage/form/'+stage+'/'),'<form')
            self.assertEqual(c.post('/stage/form/'+stage+'/save',data=data).status_code,302)
        for stage in ['formation_ab','evaluation_ab','formation_mos','evaluation_mos','formation_abx','evaluation_abx']:
            url='/stage/test/'+stage+'/'
            expected=5 if stage.startswith('formation') else 9
            self.assertEqual(
                config["stages"][stage]["nb_steps"],
                expected,
                f"{stage} : ce test attend la campagne complète ({expected} essais)",
            )
            for index in range(expected):
                body=self.page(c.get(url),'<form');parser=Inputs();parser.feed(body)
                if stage=='evaluation_ab':self.assertEqual('choice-tie' in body,index not in [1,4])
                with self.app.app_context():
                    test=TestManager().get(stage);user=next(iter(test.transactions));meta=test.transactions[user]['protocol'].copy()
                self.page(c.get(url),'<form')
                with self.app.app_context():self.assertEqual(test.transactions[user]['protocol'],meta)
                data={a['name']:a.get('value','') for a in parser.inputs if a.get('type')=='hidden'}
                radios=[a for a in parser.inputs if a.get('type')=='radio']
                if radios:
                    desired=meta['target'] if stage.endswith('abx') else 'sys1'
                    with self.app.app_context():chosen=next(a for a in radios if a['value']!='tie' and test.transactions[user][a['value']][0]==desired)
                    data[chosen['name']]=chosen['value']
                for field in parser.selects:
                    with self.app.app_context():method=test.transactions[user][field['name'].split(':')[-1]][0]
                    data[field['name']]='2' if meta.get('control')=='attention' else ('5' if method=='sys1' else '3')
                data['protocol_role']='forged'
                self.assertEqual(c.post(url+'save',data=data).status_code,302)
                if stage.startswith('formation'):self.page(c.get(url+'feedback'),'Entraînement — explication')
            self.assertEqual(c.get(url).status_code,302)
            with self.app.app_context():
                table=Table('TestSample_'+stage,MetaData(),autoload_with=db.engine);rows=[dict(zip(table.c.keys(),r)) for r in db.session.query(table).all()]
                self.assertEqual(len(rows),expected)
                if stage.startswith('formation'):
                    self.assertTrue(all(r['intro'] for r in rows));self.assertEqual({r['protocol_item'] for r in rows},set(map(str,range(5))))
                else:
                    self.assertEqual(sum(r['protocol_role']=='main' for r in rows),5)
                    self.assertTrue(all(r['protocol_correct']=='1' for r in rows if r['protocol_role']=='control'))
                    for r in rows:
                        if r['protocol_repeat_of']:
                            original=next(x for x in rows if x['protocol_step']==r['protocol_repeat_of'])
                            self.assertEqual(r['sys1'],original['sys1']);self.assertEqual(r['sys2'],original['sys2'])
                            self.assertEqual(json.loads(r['protocol_order']),json.loads(original['protocol_order'])[::-1])
        for report in config['admin']['mods'][1]['reports']:
            body=c.get('/admin/stats/?report='+report).data.decode();self.assertNotIn('HTTP status code:',body)
        self.assertNotIn('1.0 (0',c.get('/admin/stats/?report=qualite').data.decode())
        # The native, unscheduled ABX template retains its reload-stable fallback.
        first=Inputs();first.feed(self.page(c.get('/stage/test/test_abx/'),'<form'))
        second=Inputs();second.feed(self.page(c.get('/stage/test/test_abx/'),'<form'))
        refs=lambda parser:{v['name']:v.get('value') for v in parser.inputs if v.get('type')=='hidden'}
        self.assertEqual(refs(first),refs(second))

if __name__=='__main__':
    unittest.main()
