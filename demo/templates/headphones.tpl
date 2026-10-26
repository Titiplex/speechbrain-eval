{% extends get_template('ab.tpl','mod/test') %}
{% block content %}
{% if get_variable('missing_audio') %}
<p>Fichiers de contrôle casque manquants : {{ get_variable('missing_audio') }}</p>
{% else %}{{ super() }}
{% endif %}
{% endblock %}
