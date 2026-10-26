"""Optional ordered trials, using native transactions and TestSample tables."""
import json
import random
from flexeval.database import db


def scheduled(test, user, choices):
    if test.schedule is None:
        return
    index = test.nb_steps_complete_by(user)
    spec = test.schedule[index]
    line = spec['line']
    for name, (system, _) in test.systems.items():
        choices[name] = system.system_samples[line]
    order = list(choices)
    random.shuffle(order)
    target = random.choice(order)
    if 'repeat_of' in spec:
        original = test.testSampleModel.query.filter_by(
            user_pseudo=user.pseudo, protocol_step=str(spec['repeat_of'])).one()
        order = json.loads(original.protocol_order)[::-1]
        target = original.protocol_target
    test.set_in_transaction(user, 'protocol', dict(spec, index=index, order=order, target=target))


def presentation(test, user, samples, names):
    meta = test.get_in_transaction(user, 'protocol')
    order = meta['order'] if meta else list(samples)
    if not meta:
        random.shuffle(order)
    return [samples[name] for name in order if not names or name in names]


def record(test, user, response, intro):
    meta = test.get_in_transaction(user, 'protocol')
    if not meta:
        return
    kind = test.protocol_kind
    expected = meta.get('expected')
    correct = ''
    if kind == 'abx':
        # These references are computed server-side; posted values cannot replace them.
        for column, value in [('ABX_reference_A', meta['order'][0]),
                              ('ABX_reference_B', meta['order'][1]),
                              ('ABX_target', meta['target'])]:
            test.testSampleModel.addColumn(column, db.String)
            response.update(commit=False, **{column: value})
    if expected:
        if kind == 'mos' and expected == {'ordering': 'sys1>sys2'}:
            correct = str(int(float(response.MOS_score_sys1) > float(response.MOS_score_sys2)))
        elif kind == 'mos':
            correct = str(int(all(str(getattr(response, column, '')) == str(value)
                                 for column, value in expected.items())))
        else:
            column = ('ABX_choice_' if kind == 'abx' else 'ChoiceBetween_') + '_'.join(sorted(test.systems))
            correct = str(int(getattr(response, column, None) ==
                              (meta['target'] if expected == 'target' else expected)))
    values = dict(protocol_step=str(meta['index']), protocol_item=str(meta['line']),
                  protocol_role='training' if intro else meta.get('role', 'main'),
                  protocol_repeat_of=str(meta.get('repeat_of', '')),
                  protocol_order=json.dumps(meta['order']), protocol_target=meta['target'],
                  protocol_correct=correct, protocol_control=meta.get('control', ''))
    for column, value in values.items():
        test.testSampleModel.addColumn(column, db.String)
        response.update(commit=False, **{column: value})
