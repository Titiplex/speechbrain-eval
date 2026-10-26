{% extends get_template('base.tpl','flexeval') %}{% block content %}
{% include get_template('_navigation.tpl','mod/stats') %}
<h2>{{ get_variable('report_title') }}</h2>
<p>Indicateurs
    descriptifs uniquement. Pas de pondération ni d’exclusion automatique. Les faibles effectifs ne permettent pas un
    diagnostic individuel de biais.</p>
{% for title,s in get_variable('results').items() %}
<h3 class="h5">{{ title }}</h3>
<div class="table-responsive">
    <table class="table">
        <thead>
        <tr>
            <th>Participant</th>
            <th>Essais principaux / 5</th>
            <th>Contrôles réussis</th>
            <th>Contrôles manquants</th>
            <th>Écart absolu MOS répété</th>
            <th>Accord des choix répétés</th>
            <th>Choix du premier emplacement (hors égalités)</th>
        </tr>
        </thead>
        <tbody>{% for user,p in s.participants.items() %}
        <tr>
            <td>{{ user }}</td>
            <td>{{ p.main }}</td>
            <td>{{ p.correct }}/{{ p.controls }}</td>
            <td>{{ p.control_missing }}</td>
            <td>{{ p.mos_repeat_mae }} ({{ p.mos_repeat_n }} notes)</td>
            <td>{{ p.repeat_agreement }} ({{ p.repeat_n }} paires)</td>
            <td>{{ p.first_rate }} ({{ p.position_n }} choix)</td>
        </tr>{% endfor %}</tbody>
    </table>
</div>{% endfor %}
<p>Accord et positions sont des proportions 0–1. Les répétitions comparent les systèmes/fichiers, pas les lettres A/B.
    Les anciennes données sans métadonnées ne permettent pas de reconstruire leur ordre.</p>
{% endblock %}
