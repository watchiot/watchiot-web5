# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create plans static values
Plan.create(name: 'Free', amount_per_month: 0)
Plan.create(name: 'Small', amount_per_month: 7)
Plan.create(name: 'Medium', amount_per_month: 15)
Plan.create(name: 'Large', amount_per_month: 29)

Feature.create(name: 'Amount of spaces')
Feature.create(name: 'Amount of projects by space')
Feature.create(name: 'Amount of metrics by project')
Feature.create(name: 'Data retention')
Feature.create(name: 'Request per hours for each project')
Feature.create(name: 'Team members')
Feature.create(name: 'Amount of states')

# Amount of spaces
PlanFeature.create(plan_id: 1, feature_id: 1, value: '2')
PlanFeature.create(plan_id: 2, feature_id: 1, value: '4')
PlanFeature.create(plan_id: 3, feature_id: 1, value: '10')
PlanFeature.create(plan_id: 4, feature_id: 1, value: '30')

# Amount of projects by space
PlanFeature.create(plan_id: 1, feature_id: 2, value: '3')
PlanFeature.create(plan_id: 2, feature_id: 2, value: '5')
PlanFeature.create(plan_id: 3, feature_id: 2, value: '12')
PlanFeature.create(plan_id: 4, feature_id: 2, value: '30')

# Amount of metrics by project
PlanFeature.create(plan_id: 1, feature_id: 3, value: '3')
PlanFeature.create(plan_id: 2, feature_id: 3, value: '6')
PlanFeature.create(plan_id: 3, feature_id: 3, value: 'unlimited')
PlanFeature.create(plan_id: 4, feature_id: 3, value: 'unlimited')

# Data retention
PlanFeature.create(plan_id: 1, feature_id: 4, value: '7')
PlanFeature.create(plan_id: 2, feature_id: 4, value: '60')
PlanFeature.create(plan_id: 3, feature_id: 4, value: '365')
PlanFeature.create(plan_id: 4, feature_id: 4, value: 'unlimited')

# Request per hours per project
PlanFeature.create(plan_id: 1, feature_id: 5, value: '60')
PlanFeature.create(plan_id: 2, feature_id: 5, value: '360')
PlanFeature.create(plan_id: 3, feature_id: 5, value: '900')
PlanFeature.create(plan_id: 4, feature_id: 5, value: '3600')

# Team members
PlanFeature.create(plan_id: 1, feature_id: 6, value: '2')
PlanFeature.create(plan_id: 2, feature_id: 6, value: '5')
PlanFeature.create(plan_id: 3, feature_id: 6, value: 'unlimited')
PlanFeature.create(plan_id: 4, feature_id: 6, value: 'unlimited')

# Amount of states
PlanFeature.create(plan_id: 1, feature_id: 7, value: '3')
PlanFeature.create(plan_id: 2, feature_id: 7, value: '5')
PlanFeature.create(plan_id: 3, feature_id: 7, value: '10')
PlanFeature.create(plan_id: 4, feature_id: 7, value: 'unlimited')

# Project descriptions static values

Descrip.create(
    title: 'Multiplatform',
    description: '<strong>WatchIoT</strong> does not depend on any platform, you can monitor a web application hosted '\
                 'on Linux or a devices (IoT) running on Windows.',
    icon: 'cubes',
    lang: 'en'
)

Descrip.create(
    title: 'Multiplataforma',
    description: '<strong>WatchIoT</strong> no depende de ninguna plataforma, usted puede monitorear una aplicacion '\
                  'web sobre sevidores Linux o un dispositivo (IoT) corriendo sobre Windows',
    icon: 'cubes',
    lang: 'es'
)

Descrip.create(
    title: 'Configurable',
    description: 'All in <strong>WatchIoT</strong> is configurable and incredibly simple. '\
                 'You can configure all about send alerts, who and when notify and how collect your metrics.',
    icon: 'cog',
    lang: 'en'
)

Descrip.create(
    title: 'Configurable',
    description: 'Todo en <strong>WatchIoT</strong> es configurable e incre&iacute;blemente simple. '\
                 'Usted configura como manejar los services, que metricas recolectar, como enviar alertas y mas.',
    icon: 'cog',
    lang: 'es'
)

Descrip.create(
    title: 'Bidirectional',
    description: '<strong>WatchIoT</strong> can make requests to your services or your services may send requests to us '\
                 'with the metrics using a RESTful API.',
    icon: 'arrows-h',
    lang: 'en'
)

Descrip.create(
    title: 'Bidireccional',
    description: '<strong>WatchIoT</strong> puede realizar las peticiones a sus servicios o sus servicios pueden enviarnos '\
                 'peticiones a nosotros.',
    icon: 'arrows-h',
    lang: 'es'
)

Descrip.create(
    title: 'Notification',
    description: 'Notifications are in real time using differents via. You have everything under control and '\
                 'can sleep relaxed we will be alert for you.',
    icon: 'envelope',
    lang: 'en'
)

Descrip.create(
    title: 'Notificacion',
    description: 'Las notificaciones son utilizando diferentes v&iacute;as en tiempo real. Usted tiene todo bajo '\
                 'control puede dormir relajado, nosotros vamos a estar alerta por usted.',
    icon: 'envelope',
    lang: 'es'
)

# Faq static values

Faq.create(
    question: 'What services provided WatchIoT?',
    answer: '<strong>WatchIot</strong> is a monitoring service and throw alert that allows us to know in real time '\
            'if our services, resources or devices (IoT) have some behavior that we want to pay attention.',
    lang: 'en')

Faq.create(
    question: 'Que nos trae WatchIoT',
    answer: '<strong>WatchIot</strong> es un servicio de monitoreo y envio de alertas, que nos permite tener conocimiento en '\
            'tiempo real si nuestros servicios o recursos presentan alg&uacute;n  comportamiento an&oacute;malo  o no deseado.',
    lang: 'es')

Faq.create(
    question: 'How much costs the service of WatchIoT?',
    answer: '<strong>WatchIot</strong> costs nothing, it is absolutely free.',
    lang: 'en')

Faq.create(
    question: 'Es WatchIoT gratis?',
    answer: '<strong>WatchIot</strong> es absolutamente gratis.',
    lang: 'es')

Faq.create(
    question: 'I have to create spaces. What is a space?',
    answer: 'Space is a way of organizing the services, resources and devices (IoT) that you are monitoring. '\
            'For example, maybe you are monitoring services of several companies. Then you can separate each company as a space.',
    lang: 'en')

Faq.create(
    question: 'Que es un espacio?',
    answer: 'Un espacio es una forma de organizar los servicios que usted est&aacute; monitoreando. Por ejemplo, '\
            'usted puede estar monitoreando los servicios de varias empresas y puede separar cada empresa como un espacio.',
    lang: 'es')

Faq.create(
    question: 'I can create several projects into a space. What is a project?',
    answer: 'Each service, resource or device (IoT) that you are monitoring can be seen as a project. You can configure '\
            'whole respect your service. Example: what metrics do you want to collect, the url to send a request, '\
            'ip for wait the request, when throw the alert(notification), email that must receive the notification, etc. ',
    lang: 'en')

Faq.create(
    question: 'Que es un proyecto?',
    answer: 'Cada servicio o recurso que usted monitorea se configura como un proyecto. Por ejemplo, que metricas voy a recolectar, '\
            'cada que tiempo voy a enviar una petici&oacute;n de recoleccion de metricas o recibirla, '\
            'como voy a evaluar la metricas obtenidas para conocer que accion tomar, a quien voy a notificar, etc.',
    lang: 'es')

Faq.create(
    question: 'How many spaces can be related to my account?',
    answer: 'You can create a maximum of 2 spaces. If you require more space please contact us.',
    lang: 'en')

Faq.create(
    question: 'Cuantos espacios puedo tener relacionado a mi cuenta?',
    answer: 'Usted puede crear un m&aacute;ximo de 2 espacios. Si usted requiere m&aacute;s espacios por favor p&oacute;ngase '\
            'en contacto con nosotros.',
    lang: 'es')

Faq.create(
    question: 'How many projects for space?',
    answer: 'You can have a maximum of 3 projects for space. If you require more space projects please contact us.',
    lang: 'en')

Faq.create(
    question: 'Cuantos proyectos puedo tener por espacio?',
    answer: 'Usted puede tener un m&aacute;ximo de 3 proyectos por espacio. Si usted requiere m&aacute;s proyectos '\
            'por espacio por favor p&oacute;ngase en contacto con nosotros.',
    lang: 'es')

Faq.create(
    question: 'Can I add friends to manage the spaces and projects?',
    answer: 'You have the ability to invite friends to help you manage spaces and projects, and receive alerts too.',
    lang: 'en')

Faq.create(
    question: 'Puedo agregar amigos para que administren mis espacios y proyectos',
    answer: 'Usted tiene la posibilidad de invitar amigos a que le ayuden a administrar los espacios y proyectos, adem&aacute;s '\
            'de recibir alertas.',
    lang: 'es')

Faq.create(
    question: 'How many metrics can I submit for each request?',
    answer: 'You can send a maximum of 3 metrics per request that are previously configured in the project. '\
            'If you need to collect more metrics by request please contact us.',
    lang: 'en')

Faq.create(
    question: 'Que cantidad de metricas puedo enviar por cada petici&oacute;n?',
    answer: 'Usted puede enviar un m&aacute;ximo de 3 metricas por peticion que esten previamente configuradas en el proyecto. '\
            'Si usted requiere recolectar m&aacute;s  metricas por petici&oacute;n por favor p&oacute;ngase en contacto con nosotros.',
    lang: 'es')

Faq.create(
    question: 'How many times per hour can I send the metrics collected?',
    answer: 'You can send 60 times the collected metrics for each hour or once per minute to our servers '\
            'If you need to increase the frequency of submission of the metrics collect please get in touch with us.',
    lang: 'en')

Faq.create(
    question: 'Cuantas veces por hora puedo enviar las metricas recolectadas?',
    answer: 'Usted puede enviar 60 veces las metricas recolectadas por cada hora o una vez por minuto a nuestro servidores '\
            'Si usted necesita aumentar la frecuencia de envio de las metricas recolectar por favor p&oacute;ngase en contacto con nosotros.',
    lang: 'es')

Faq.create(
    question: 'How long do the metrics collected data persist?',
    answer: 'The metric data collected is stored in our databases for a period of 7 days, '\
            'if you want to store the metrics collect for a longer period of time please contact us.',
    lang: 'en')

Faq.create(
    question: 'Que tiempo persisten los datos de las metricas recolectadas?',
    answer: 'Los datos de las metricas recolectadas se almacena en nuestras bases de datos por un periodo de 7 dias '\
            'Si usted desea almacenar las metricas recolectar por un periodo de tiempo m&aacute;s largo por favor '\
            'p&oacute;ngase en contacto con nosotros.',
    lang: 'es')
