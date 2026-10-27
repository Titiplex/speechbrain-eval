{% extends get_template('base.tpl','flexeval') %}{% block content %}
{% include get_template('_navigation.tpl','mod/stats') %}
<h2>{{ get_variable('report_title') }}</h2>
{% for title,s in get_variable('results').items() %}
<h3 class="h5">{{ title }}</h3>
<p>{{ s.n }} réponses principales ; {{ s.participants }} participants ; {{ s.missing }} réponses manquantes /
    invalides.</p>
<table class="table">
    <thead>
    <tr>
        <th>Choix (ABX : 1 = correct)</th>
        <th>Effectif</th>
        <th>Proportion brute</th>
    </tr>
    </thead>
    <tbody>{% for name,v in s.counts.items() %}
    <tr>
        <td>{{ name }}</td>
        <td>{{ v.count }}</td>
        <td>{{ '%.1f'|format(v.rate*100) ~ ' %' if v.rate is not none else '—' }}</td>
    </tr>{% endfor %}
    </tbody>
</table>
<p>Moyenne des proportions par participant (sys1 pour A/B, réussite pour ABX) : {{ s.participant_mean }} ; IC de
    Student {{ s.ci }}. Cet IC approximatif peut dépasser 0–1 et n’est pas tronqué.</p>
{% if not s.individual %}
<p>Préférence sys1 parmi décisions : {{ s.decisive_sys1 }}. Partage descriptif des égalités
    : {{ s.shared_ties }}.</p>
{% else %}
<p>ABX : un score proche de 50 % ne prouve pas l’inattention. Les p-values
    ci-dessous sont exploratoires, individuelles et supposent les essais indépendants avec une probabilité nulle de 0,5
    ; elles ne sont pas un critère d’exclusion. Pas de test binomial regroupant tous les auditeurs.</p>
<details>
    <summary>Détails individuels ABX</summary>
    {% for user,v in s.individual.items() %}
    <p>
        {{ user }} : {{ v.correct }}/{{ v.n }} ; p unilatérale {{ v.p }}.
    </p>
    {% endfor %}
</details>
{% endif %}
{% endfor %}{% endblock %}
