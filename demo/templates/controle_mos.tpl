{% extends get_template('mos.tpl', 'mod/test') %}
{% block content %}
<div class="alert alert-info">Pour cette étape, suivez en priorité la consigne parlée dans les extraits.</div>
{{ super() }}
{% endblock %}
