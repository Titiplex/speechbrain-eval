{% extends get_template('base.tpl', 'flexeval') %}

{% block content %}

<h2>Statistics and Results</h2>
<p class="text-muted">
    Please select a test to see associated Results and Stats
</p>

<div class="row mt-4">
    {% for page in get_variable("navigation") %}
    <div class="col-12 col-md-6 mb-4">
        <article class="card h-100">
            <div class="card-body d-flex flex-column">
                <h3 class="h5 card-title">
                    {{ page.title }}
                </h3>

                <p class="card-text text-muted">
                    {{ page.description }}
                </p>

                <div class="mt-auto pt-3">
                    <a href="{{ page.url }}" class="btn btn-primary">
                        See Results
                        <span class="sr-only">
                            — {{ page.title }}
                        </span>
                    </a>
                </div>
            </div>
        </article>
    </div>
    {% else %}
    <div class="col-12">
        <p>No report configured for this test.</p>
    </div>
    {% endfor %}
</div>

<a href="{{homepage}}"> Back to admin panel.</a>

{% endblock %}