{% extends get_template('base.tpl','flexeval') %}
{% block content %}
<h2>Conditions d’écoute</h2><
p>Réglez le volume à un niveau confortable et gardez-le stable. Privilégiez un endroit calme.</p>
<form action="./save" method="post"><label>Matériel<select name="equipment" required>
            <option value="">Choisir</option>
            <option value="headphones">Casque / écouteurs</option>
            <option value="speakers">Haut-parleurs</option>
        </select></label><label>Environnement<select name="environment" required>
            <option value="">Choisir</option>
            <option value="quiet">Calme</option>
            <option value="noisy">Bruyant</option>
        </select></label><label><input type="checkbox" name="volume_ready" value="yes" required>Le volume est
        confortable.</label>
    <button type="submit">Continuer</button>
</form>{% endblock %}