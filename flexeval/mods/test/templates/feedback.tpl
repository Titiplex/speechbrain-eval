{% extends get_template('base.tpl','flexeval') %}
{% block content %}
<h2>Entraînement — explication</h2>
<p>{{ get_variable('explanation') }}</p>
<p>Pour le MOS, aucune note exacte n’est imposée. Pour ABX, identifiez la copie
    ; ne choisissez pas votre version préférée.</p>
<a class="btn btn-primary" href="{{ make_url(get_variable('continue_url')) }}">Continuer</a>
{% endblock %}