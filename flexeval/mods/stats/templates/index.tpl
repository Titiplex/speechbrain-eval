{% extends get_template('base.tpl', 'flexeval') %}

{% block content %}
<h2 class="bd-content-title"><img src="{{get_asset('/img/svg_icon/chevron-right.svg','flexeval')}}"
                                  alt=">"/> {{get_variable("subtitle",default_value="Statistics")}}</h2>

<p>{{ get_variable("message") }}</p>

<a href="{{homepage}}"> Back to admin panel.</a>
{% endblock %}