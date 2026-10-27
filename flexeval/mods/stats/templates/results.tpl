{% extends get_template('base.tpl','flexeval') %}
{% block content %}
{% include get_template('_navigation.tpl','mod/stats') %}
<h2>{{ get_variable('report_title') }}</h2>
<p>Seuls les essais principaux sont inclus. IC 95 % de Student sur les moyennes par participant, conditionnels aux
    extraits testés. Un IC indisponible nécessite au moins deux participants et SciPy. Les contrôles et répétitions sont
    analysés séparément.</p>
{% for name,s in get_variable('results').items() %}
<section>
    <h3 class="h5">{{ name }}</h3>
    {% if s.get('message') %}
    <p>{{ s.message }}</p>
    {% endif %}
    <table class="table">
        <thead>
        <tr>
            <th>Notes</th>
            <th>Participants</th>
            <th>Moyenne brute</th>
            <th>Médiane</th>
            <th>Écart-type des notes</th>
            <th>Moyenne par participant</th>
            <th>IC 95 %</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>{{ s.n }}</td>
            <td>{{ s.participants }}</td>
            <td>{{ s.mean }}</td>
            <td>{{ s.median }}</td>
            <td>{{ s.std }}</td>
            <td>{{ s.participant_mean }}</td>
            <td>{{ s.ci if s.ci is not none else 'Indisponible' }}</td>
        </tr>
        </tbody>
    </table>
    <p>{{ s["items"] }} extraits distincts.</p>
    <details>
        <summary>Par extrait</summary>
        {% for item,v in s.by_item.items() %}
        <p>{{ item }} : {{ v.n }} notes, moyenne {{ v.mean }}</p>
        {% endfor %}
    </details>
    <p>Distribution : {{ s.distribution }}. Manquantes : {{ s.missing }} ; invalides : {{ s.invalid }}.</p>
    {% if s.get('paired') %}{% set p=s.paired %}
    <p>Comparaison appariée sys1 − sys2 : {{ p.n }} participants ;
        différence {{ p.difference }} ; IC {{ p.ci }} ; p bilatérale {{ p.p if p.p is not none else 'Indisponible' }}.
        Approximation de Student, différences entre participants indépendantes ; pas de correction des comparaisons
        multiples. Variance nulle : p non calculée.
    </p>
    {% endif %}
</section>
{% endfor %}
{% endblock %}
