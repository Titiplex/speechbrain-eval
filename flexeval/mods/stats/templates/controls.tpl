{% extends get_template('base.tpl', 'flexeval') %}
{% block content %}
<a class="btn btn-outline-primary" href="{{ get_variable('menu_url') }}">← Tous les rapports</a>
<h2>{{ get_variable('report_title') }}</h2>
<p>Ces indicateurs décrivent les réponses aux consignes. Deux contrôles ne suffisent pas à établir la fiabilité globale
    d’un participant. Aucune exclusion ou pondération automatique.</p>
{% for title, result in get_variable('results').items() %}
<h3 class="h5">{{ title }}</h3>
{% if result.get('message') %}
<p>{{ result['message'] }}</p>{% endif %}
<table class="table">
    <thead>
    <tr>
        <th>Participant</th>
        <th>Réussites / réponses complètes</th>
        <th>Manquantes</th>
        <th>Réussite</th>
    </tr>
    </thead>
    <tbody>
    {% for user, counts in result['participants'].items() %}
    <tr>
        <td>{{ user }}</td>
        <td>{{ counts['correct'] }}/{{ counts['n'] }}</td>
        <td>{{ counts['missing'] }}</td>
        <td>{{ '%.0f'|format(100 * counts['rate']) ~ ' %' if counts['rate'] is not none else '—' }}</td>
    </tr>
    {% else %}
    <tr>
        <td colspan="4">Aucune donnée.</td>
    </tr>
    {% endfor %}
    </tbody>
</table>
{% endfor %}
{% endblock %}
