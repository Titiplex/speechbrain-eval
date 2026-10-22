{% extends get_template('base.tpl', 'flexeval') %}
{% block content %}
<div class="eyebrow">Démonstration locale</div><h1>Avant votre participation</h1>
<div class="panel">
    {% if get_variable('validate') %}
    <form method="post" action="{{ make_url('/legal_terms/ok') }}">
        <label class="choice"><input type="checkbox" name="demo_agreement" value="yes" required>
            Je souhaite essayer la démonstration.</label>
        <button type="submit">Accéder à la démonstration</button>
    </form>
    {% endif %}
</div>
{% endblock %}
