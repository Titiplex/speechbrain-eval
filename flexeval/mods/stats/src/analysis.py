"""Small summaries over native TestSample rows; no new storage or weighting."""
import json
from collections import Counter, defaultdict
from statistics import mean, median, stdev
from math import sqrt, isfinite
try:
    from scipy.stats import t, ttest_1samp, binomtest
except ImportError:
    t = ttest_1samp = binomtest = None


def main_rows(rows):
    return [r for r in rows if not r.get('intro') and r.get('protocol_role') in (None, '', 'main')]


def interval(values):
    if len(values)<2 or t is None:
        return None
    m=mean(values);delta=float(t.ppf(.975,len(values)-1))*stdev(values)/sqrt(len(values))
    return [m-delta,m+delta]


def numeric(rows, column):
    numbers=[];by_user=defaultdict(list);by_item=defaultdict(list);missing=invalid=0
    for row in main_rows(rows):
        value=row.get(column)
        if value in (None,''):
            missing+=1;continue
        try:
            value=float(value)
            if not isfinite(value) or not 1<=value<=5:raise ValueError()
        except (ValueError,TypeError):
            invalid+=1;continue
        numbers.append(value);by_user[row['user_pseudo']].append(value)
        by_item[str(row.get('protocol_item', row.get('sys1', 'inconnu')))].append(value)
    people=[mean(v) for v in by_user.values()]
    return dict(n=len(numbers),mean=mean(numbers) if numbers else None,
        std=stdev(numbers) if len(numbers)>1 else None,median=median(numbers) if numbers else None,
        distribution=dict(sorted(Counter(numbers).items())),missing=missing,invalid=invalid,
        items=len(by_item),by_item={item:dict(n=len(v),mean=mean(v)) for item,v in by_item.items()},
        participants=len(people),participant_mean=mean(people) if people else None,ci=interval(people))


def paired(rows, columns):
    by_user=defaultdict(list)
    for row in main_rows(rows):
        try:
            a,b=(float(row[c]) for c in columns)
            if not all(isfinite(v) and 1<=v<=5 for v in (a,b)):continue
            by_user[row['user_pseudo']].append(a-b)
        except (KeyError,ValueError,TypeError):continue
    differences=[mean(v) for v in by_user.values()]
    p=float(ttest_1samp(differences,0).pvalue) if ttest_1samp and len(differences)>1 and stdev(differences)>0 else None
    return dict(n=len(differences),difference=mean(differences) if differences else None,ci=interval(differences),p=p)


def categorical(rows, kind):
    rows=main_rows(rows);people=defaultdict(list);votes=Counter();missing=0
    column='ABX_choice_sys1_sys2' if kind=='abx' else 'ChoiceBetween_sys1_sys2'
    for row in rows:
        choice=row.get(column)
        if choice not in ('sys1','sys2','tie') or (kind=='abx' and row.get('ABX_target') not in ('sys1','sys2')):
            missing+=1;continue
        value=str(int(choice==row['ABX_target'])) if kind=='abx' else choice
        votes[value]+=1;people[row['user_pseudo']].append(value)
    n=sum(votes.values())
    keys=('1','0') if kind=='abx' else ('sys1','sys2','tie')
    result={key:dict(count=votes[key],rate=votes[key]/n if n else None) for key in keys}
    participant_rates=[mean(int(v==keys[0]) for v in values) for values in people.values()]
    # A pooled binomial p-value is deliberately absent: repeated votes are clustered.
    individual={u:dict(n=len(v),correct=v.count('1'),p=float(binomtest(v.count('1'),len(v),.5,alternative='greater').pvalue)
                      if binomtest else None) for u,v in people.items()} if kind=='abx' else {}
    return dict(n=n,participants=len(people),missing=missing,counts=result,
        participant_mean=mean(participant_rates) if participant_rates else None,ci=interval(participant_rates),
        decisive_sys1=votes['sys1']/(votes['sys1']+votes['sys2']) if votes['sys1']+votes['sys2'] else None,
        shared_ties=(votes['sys1']+votes['tie']/2)/n if n and kind=='ab' else None,individual=individual)


def quality(rows, kind):
    users=defaultdict(list)
    for row in rows:users[row['user_pseudo']].append(row)
    result={}
    for user,group in users.items():
        lookup={r.get('protocol_step'):r for r in group if r.get('protocol_step') is not None}
        controls=[r for r in group if r.get('protocol_role')=='control']
        valid=[r['protocol_correct'] for r in controls if r.get('protocol_correct') in ('0','1')]
        gaps=[];agreements=[];positions=[]
        for row in group:
            if row.get('protocol_role')=='repeat':
                original=lookup.get(row.get('protocol_repeat_of'))
                if original:
                    if kind=='mos':
                        for c in ['MOS_score_sys1','MOS_score_sys2']:
                            try:gaps.append(abs(float(row[c])-float(original[c])))
                            except (KeyError,TypeError,ValueError):pass
                    else:
                        c='ABX_choice_sys1_sys2' if kind=='abx' else 'ChoiceBetween_sys1_sys2'
                        if row.get(c) and original.get(c):agreements.append(row[c]==original[c])
            if kind=='ab' and row in main_rows(group) and row.get('ChoiceBetween_sys1_sys2') in ('sys1','sys2'):
                order=json.loads(row.get('protocol_order') or '[]')
                if order:positions.append(row['ChoiceBetween_sys1_sys2']==order[0])
        result[user]=dict(main=len(main_rows(group)),controls=len(valid),correct=valid.count('1'),
            control_missing=len(controls)-len(valid),repeat_n=len(agreements),repeat_agreement=mean(agreements) if agreements else None,
            mos_repeat_n=len(gaps),mos_repeat_mae=mean(gaps) if gaps else None,
            position_n=len(positions),first_rate=mean(positions) if positions else None)
    return dict(participants=result)
