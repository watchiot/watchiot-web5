# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Plans
freePlan = Plan.create_with(amount_per_month: 0).find_or_create_by(name: 'Free')
hobbyPlan = Plan.create_with(amount_per_month: 7).find_or_create_by(name: 'Hobby')
professionalPlan = Plan.create_with(amount_per_month: 29).find_or_create_by(name: 'Professional')

# Features
amountSpaceFeature = Feature.find_or_create_by(name: 'Amount of spaces')
amountOfProjectBySpaceFeature = Feature.find_or_create_by(name: 'Amount of projects by space')
amountOfMetricsByProjectFeature = Feature.find_or_create_by(name: 'Amount of metrics by project')
dataRetentionFeature = Feature.find_or_create_by(name: 'Data retention')
requestPerHourFeature = Feature.find_or_create_by(name: 'Request per hours for each project')
teamMembersFeature = Feature.find_or_create_by(name: 'Team members')
amountOfStatesFeature = Feature.find_or_create_by(name: 'Amount of states')

# Amount of spaces
PlanFeature.create(
    plan_id: freePlan.id,
    feature_id: amountSpaceFeature.id,
    value: '2'
) unless PlanFeature.where(plan_id: freePlan.id, feature_id: amountSpaceFeature.id).exists?

PlanFeature.create(
    plan_id: hobbyPlan.id,
    feature_id: amountSpaceFeature.id,
    value: '4'
) unless PlanFeature.exists?({plan_id: hobbyPlan.id, feature_id: amountSpaceFeature.id})

PlanFeature.create(
    plan_id: professionalPlan.id,
    feature_id: amountSpaceFeature.id,
    value: '30'
) unless PlanFeature.exists?({plan_id: professionalPlan.id, feature_id: amountSpaceFeature.id})

# Amount of projects by space
PlanFeature.create(
    plan_id: freePlan.id,
    feature_id: amountOfProjectBySpaceFeature.id,
    value: '3'
)  unless PlanFeature.exists?({plan_id: freePlan.id, feature_id: amountOfProjectBySpaceFeature.id})

PlanFeature.create(
    plan_id: hobbyPlan.id,
    feature_id: amountOfProjectBySpaceFeature.id,
    value: '5'
) unless PlanFeature.exists?({plan_id: hobbyPlan.id, feature_id: amountOfProjectBySpaceFeature.id})

PlanFeature.create(
    plan_id: professionalPlan.id,
    feature_id: amountOfProjectBySpaceFeature.id,
    value: '30'
) unless PlanFeature.exists?({plan_id: professionalPlan.id, feature_id: amountOfProjectBySpaceFeature.id})

# Amount of metrics by project
PlanFeature.create(
    plan_id: freePlan.id,
    feature_id: amountOfMetricsByProjectFeature.id,
    value: '3'
) unless PlanFeature.exists?({plan_id: freePlan.id, feature_id: amountOfMetricsByProjectFeature.id})

PlanFeature.create(
    plan_id: hobbyPlan.id,
    feature_id: amountOfMetricsByProjectFeature.id,
    value: '6'
) unless PlanFeature.exists?({plan_id: freePlan.id, feature_id: amountOfMetricsByProjectFeature.id})

PlanFeature.create(
    plan_id: professionalPlan.id,
    feature_id: amountOfMetricsByProjectFeature.id,
    value: 'unlimited'
) unless PlanFeature.exists?({plan_id: professionalPlan.id, feature_id: amountOfMetricsByProjectFeature.id})

# Data retention
PlanFeature.create(
    plan_id: freePlan.id,
    feature_id: dataRetentionFeature.id,
    value: '7'
) unless PlanFeature.exists?({plan_id: freePlan.id, feature_id: dataRetentionFeature.id})

PlanFeature.create(
    plan_id: hobbyPlan.id,
    feature_id: dataRetentionFeature.id,
    value: '60'
) unless PlanFeature.exists?({plan_id: hobbyPlan.id, feature_id: dataRetentionFeature.id})

PlanFeature.create(
    plan_id: professionalPlan.id,
    feature_id: dataRetentionFeature.id,
    value: '360'
) unless PlanFeature.exists?({plan_id: professionalPlan.id, feature_id: dataRetentionFeature.id})

# Request per hours per project
PlanFeature.create(
    plan_id: freePlan.id,
    feature_id: requestPerHourFeature.id,
    value: '60'
    ) unless PlanFeature.exists?({plan_id: freePlan.id, feature_id: requestPerHourFeature.id})

PlanFeature.create(
    plan_id: hobbyPlan.id,
    feature_id: requestPerHourFeature.id,
    value: '360'
    ) unless PlanFeature.exists?({plan_id: hobbyPlan.id, feature_id: requestPerHourFeature.id})

PlanFeature.create(
    plan_id: professionalPlan.id,
    feature_id: requestPerHourFeature.id,
    value: '3600'
    ) unless PlanFeature.exists?({plan_id: professionalPlan.id, feature_id: requestPerHourFeature.id})

# Team members
PlanFeature.create(
    plan_id: freePlan.id,
    feature_id: teamMembersFeature.id,
    value: '2'
) unless PlanFeature.exists?({plan_id: freePlan.id, feature_id: teamMembersFeature.id})

PlanFeature.create(
    plan_id: hobbyPlan.id,
    feature_id: teamMembersFeature.id,
    value: '5'
) unless PlanFeature.exists?({plan_id: hobbyPlan.id, feature_id: teamMembersFeature.id})

PlanFeature.create(
    plan_id: professionalPlan.id,
    feature_id: teamMembersFeature.id,
    value: 'unlimited'
) unless PlanFeature.exists?({plan_id: professionalPlan.id, feature_id: teamMembersFeature.id})

# Amount of states
PlanFeature.create(
    plan_id: freePlan.id,
    feature_id: amountOfStatesFeature.id,
    value: '3'
) unless PlanFeature.exists?({plan_id: freePlan.id, feature_id: amountOfStatesFeature.id})

PlanFeature.create(
    plan_id: hobbyPlan.id,
    feature_id: amountOfStatesFeature.id,
    value: '5'
) unless PlanFeature.exists?({plan_id: hobbyPlan.id, feature_id: amountOfStatesFeature.id})

PlanFeature.create(
    plan_id: professionalPlan.id,
    feature_id: amountOfStatesFeature.id,
    value: 'unlimited'
) unless PlanFeature.exists?({plan_id: professionalPlan.id, feature_id: amountOfStatesFeature.id})

# Project descriptions static values

Descrip.create(
    title: 'Multiplatform',
    description: '<strong>WatchIoT</strong> does not depend on any platform, you can monitor a web application hosted '\
                 'on Linux or a devices (IoT) running on Windows.',
    icon: 'cubes',
    lang: 'en'
) until Descrip.exists?(title: 'Multiplatform')

Descrip.create(
    title: 'Multiplataforma',
    description: '<strong>WatchIoT</strong> no depende de ninguna plataforma, usted puede monitorear una aplicacion '\
                  'web sobre sevidores Linux o un dispositivo (IoT) corriendo sobre Windows',
    icon: 'cubes',
    lang: 'es'
) until Descrip.exists?(title: 'Multiplataforma')

Descrip.create(
    title: 'Configurable',
    description: 'All in <strong>WatchIoT</strong> is configurable and incredibly simple. '\
                 'You can configure all about send alerts, who and when notify and how collect your metrics.',
    icon: 'cog',
    lang: 'en'
) until Descrip.exists?({title: 'Configurable', lang: 'en'})

Descrip.create(
    title: 'Configurable',
    description: 'Todo en <strong>WatchIoT</strong> es configurable e incre&iacute;blemente simple. '\
                 'Usted configura como manejar los services, que metricas recolectar, como enviar alertas y mas.',
    icon: 'cog',
    lang: 'es'
) until Descrip.exists?({title: 'Configurable', lang: 'es'})

Descrip.create(
    title: 'Bidirectional',
    description: '<strong>WatchIoT</strong> can make requests to your services or your services may send requests to us '\
                 'with the metrics using a RESTful API.',
    icon: 'arrows-h',
    lang: 'en'
) until Descrip.exists?(title: 'Bidirectional')

Descrip.create(
    title: 'Bidireccional',
    description: '<strong>WatchIoT</strong> puede realizar las peticiones a sus servicios o sus servicios pueden enviarnos '\
                 'peticiones a nosotros.',
    icon: 'arrows-h',
    lang: 'es'
) until Descrip.exists?(title: 'Bidireccional')

Descrip.create(
    title: 'Notification',
    description: 'Notifications are in real time using differents via. You have everything under control and '\
                 'can sleep relaxed we will be alert for you.',
    icon: 'envelope',
    lang: 'en'
) until Descrip.exists?(title: 'Notification')

Descrip.create(
    title: 'Notificacion',
    description: 'Las notificaciones son utilizando diferentes v&iacute;as en tiempo real. Usted tiene todo bajo '\
                 'control puede dormir relajado, nosotros vamos a estar alerta por usted.',
    icon: 'envelope',
    lang: 'es'
) until Descrip.exists?(title: 'Notificacion')

# Faq static values

Faq.create(
    question: 'What services provided WatchIoT?',
    answer: '<strong>WatchIot</strong> is a monitoring service and throw alert that allows us to know in real time '\
            'if our services, resources or devices (IoT) have some behavior that we want to pay attention.',
    lang: 'en'
) until Faq.exists?(question: 'What services provided WatchIoT?')

Faq.create(
    question: 'Que nos trae WatchIoT',
    answer: '<strong>WatchIot</strong> es un servicio de monitoreo y envio de alertas, que nos permite tener conocimiento en '\
            'tiempo real si nuestros servicios o recursos presentan alg&uacute;n  comportamiento an&oacute;malo  o no deseado.',
    lang: 'es'
) until Faq.exists?(question: 'Que nos trae WatchIoT')

Faq.create(
    question: 'How much costs the service of WatchIoT?',
    answer: '<strong>WatchIot</strong> costs nothing, it is absolutely free.',
    lang: 'en'
) until Faq.exists?(question: 'How much costs the service of WatchIoT?')

Faq.create(
    question: 'Es WatchIoT gratis?',
    answer: '<strong>WatchIot</strong> es absolutamente gratis.',
    lang: 'es'
) until Faq.exists?(question: 'Es WatchIoT gratis?')

Faq.create(
    question: 'I have to create spaces. What is a space?',
    answer: 'Space is a way of organizing the services, resources and devices (IoT) that you are monitoring. '\
            'For example, maybe you are monitoring services of several companies. Then you can separate each company as a space.',
    lang: 'en'
) until Faq.exists?(question: 'I have to create spaces. What is a space?')

Faq.create(
    question: 'Que es un espacio?',
    answer: 'Un espacio es una forma de organizar los servicios que usted est&aacute; monitoreando. Por ejemplo, '\
            'usted puede estar monitoreando los servicios de varias empresas y puede separar cada empresa como un espacio.',
    lang: 'es'
) until Faq.exists?(question: 'Que es un espacio?')

Faq.create(
    question: 'I can create several projects into a space. What is a project?',
    answer: 'Each service, resource or device (IoT) that you are monitoring can be seen as a project. You can configure '\
            'whole respect your service. Example: what metrics do you want to collect, the url to send a request, '\
            'ip for wait the request, when throw the alert(notification), email that must receive the notification, etc. ',
    lang: 'en'
) until Faq.exists?(question: 'I can create several projects into a space. What is a project?')

Faq.create(
    question: 'Que es un proyecto?',
    answer: 'Cada servicio o recurso que usted monitorea se configura como un proyecto. Por ejemplo, que metricas voy a recolectar, '\
            'cada que tiempo voy a enviar una petici&oacute;n de recoleccion de metricas o recibirla, '\
            'como voy a evaluar la metricas obtenidas para conocer que accion tomar, a quien voy a notificar, etc.',
    lang: 'es'
) until Faq.exists?(question: 'Que es un proyecto?')

Faq.create(
    question: 'How many spaces can be related to my account?',
    answer: 'You can create a maximum of 2 spaces. If you require more space please contact us.',
    lang: 'en'
) until Faq.exists?(question: 'How many spaces can be related to my account?')

Faq.create(
    question: 'Cuantos espacios puedo tener relacionado a mi cuenta?',
    answer: 'Usted puede crear un m&aacute;ximo de 2 espacios. Si usted requiere m&aacute;s espacios por favor p&oacute;ngase '\
            'en contacto con nosotros.',
    lang: 'es'
) until Faq.exists?(question: 'Cuantos espacios puedo tener relacionado a mi cuenta?')

Faq.create(
    question: 'How many projects for space?',
    answer: 'You can have a maximum of 3 projects for space. If you require more space projects please contact us.',
    lang: 'en'
) until Faq.exists?(question: 'How many projects for space?')

Faq.create(
    question: 'Cuantos proyectos puedo tener por espacio?',
    answer: 'Usted puede tener un m&aacute;ximo de 3 proyectos por espacio. Si usted requiere m&aacute;s proyectos '\
            'por espacio por favor p&oacute;ngase en contacto con nosotros.',
    lang: 'es'
) until Faq.exists?(question: 'Cuantos proyectos puedo tener por espacio?')

Faq.create(
    question: 'Can I add friends to manage the spaces and projects?',
    answer: 'You have the ability to invite friends to help you manage spaces and projects, and receive alerts too. '\
            'You have a maximum of 2 invite friends, if you require more please contact us.',
    lang: 'en'
) until Faq.exists?(question: 'Can I add friends to manage the spaces and projects?')

Faq.create(
    question: 'Puedo agregar amigos para que administren mis espacios y proyectos',
    answer: 'Usted tiene la posibilidad de invitar amigos a que le ayuden a administrar los espacios y proyectos, adem&aacute;s '\
            'de recibir alertas. Usted tiene un m&aacute;ximo de invitar dos amigos. Si usted requiere m&aacute;s '\
            'por favor p&oacute;ngase en contacto con nosotros.',
    lang: 'es'
) until Faq.exists?(question: 'Puedo agregar amigos para que administren mis espacios y proyectos')

Faq.create(
    question: 'How many metrics can I submit for each request?',
    answer: 'You can send a maximum of 3 metrics per request that are previously configured in the project. '\
            'If you need to collect more metrics by request please contact us.',
    lang: 'en'
) until Faq.exists?(question: 'How many metrics can I submit for each request?')

Faq.create(
    question: 'Que cantidad de metricas puedo enviar por cada petici&oacute;n?',
    answer: 'Usted puede enviar un m&aacute;ximo de 3 metricas por peticion que esten previamente configuradas en el proyecto. '\
            'Si usted requiere recolectar m&aacute;s  metricas por petici&oacute;n por favor p&oacute;ngase en contacto con nosotros.',
    lang: 'es'
) until Faq.exists?(question: 'Que cantidad de metricas puedo enviar por cada petici&oacute;n?')

Faq.create(
    question: 'How many times per hour can I send the metrics collected?',
    answer: 'You can send 60 times the collected metrics for each hour or once per minute to our servers '\
            'If you need to increase the frequency of submission of the metrics collect please get in touch with us.',
    lang: 'en'
) until Faq.exists?(question: 'How many times per hour can I send the metrics collected?')

Faq.create(
    question: 'Cuantas veces por hora puedo enviar las metricas recolectadas?',
    answer: 'Usted puede enviar 60 veces las metricas recolectadas por cada hora o una vez por minuto a nuestro servidores '\
            'Si usted necesita aumentar la frecuencia de envio de las metricas recolectar por favor p&oacute;ngase en contacto con nosotros.',
    lang: 'es'
) until Faq.exists?(question: 'Cuantas veces por hora puedo enviar las metricas recolectadas?')

Faq.create(
    question: 'How long do the metrics collected data persist?',
    answer: 'The metric data collected is stored in our databases for a period of 7 days, '\
            'if you want to store the metrics collect for a longer period of time please contact us.',
    lang: 'en'
) until Faq.exists?(question: 'How long do the metrics collected data persist?')

Faq.create(
    question: 'Que tiempo persisten los datos de las metricas recolectadas?',
    answer: 'Los datos de las metricas recolectadas se almacena en nuestras bases de datos por un periodo de 7 dias '\
            'Si usted desea almacenar las metricas recolectar por un periodo de tiempo m&aacute;s largo por favor '\
            'p&oacute;ngase en contacto con nosotros.',
    lang: 'es'
) until Faq.exists?(question: 'Que tiempo persisten los datos de las metricas recolectadas?')

# Countries
Country.create(code: 'af', name: 'Afghanistan', prefix: '93') unless Country.exists?(code: 'af')
Country.create(code: 'al', name: 'Albania', prefix: '355') unless Country.exists?(code: 'al')
Country.create(code: 'dz', name: 'Algeria', prefix: '213') unless Country.exists?(code: 'dz')
Country.create(code: 'as', name: 'American Samoa', prefix: '1684') unless Country.exists?(code: 'as')
Country.create(code: 'ad', name: 'Andorra', prefix: '376') unless Country.exists?(code: 'ad')
Country.create(code: 'ao', name: 'Angola', prefix: '244') unless Country.exists?(code: 'ao')
Country.create(code: 'ai', name: 'Anguilla', prefix: '1264') unless Country.exists?(code: 'ai')
Country.create(code: 'ag', name: 'Antigua and Barbuda', prefix: '1268') unless Country.exists?(code: 'ag')
Country.create(code: 'ar', name: 'Argentina', prefix: '54') unless Country.exists?(code: 'ar')
Country.create(code: 'am', name: 'Armenia', prefix: '374') unless Country.exists?(code: 'am')
Country.create(code: 'aw', name: 'Aruba', prefix: '297') unless Country.exists?(code: 'aw')
Country.create(code: 'au', name: 'Australia/Cocos/Christmas Island', prefix: '61') unless Country.exists?(code: 'au')
Country.create(code: 'at', name: 'Austria', prefix: '43') unless Country.exists?(code: 'at')
Country.create(code: 'az', name: 'Azerbaijan', prefix: '994') unless Country.exists?(code: 'az')
Country.create(code: 'bs', name: 'Bahamas', prefix: '1') unless Country.exists?(code: 'bs')
Country.create(code: 'bh', name: 'Bahrain', prefix: '973') unless Country.exists?(code: 'bh')
Country.create(code: 'bd', name: 'Bangladesh', prefix: '880') unless Country.exists?(code: 'bd')
Country.create(code: 'bb', name: 'Barbados', prefix: '1246') unless Country.exists?(code: 'bb')
Country.create(code: 'by', name: 'Belarus', prefix: '375') unless Country.exists?(code: 'by')
Country.create(code: 'be', name: 'Belgium', prefix: '32') unless Country.exists?(code: 'be')
Country.create(code: 'bz', name: 'Belize', prefix: '501') unless Country.exists?(code: 'bz')
Country.create(code: 'bj', name: 'Benin', prefix: '229') unless Country.exists?(code: 'bj')
Country.create(code: 'bm', name: 'Bermuda', prefix: '1441') unless Country.exists?(code: 'bm')
Country.create(code: 'bo', name: 'Bolivia', prefix: '591') unless Country.exists?(code: 'bo')
Country.create(code: 'ba', name: 'Bosnia and Herzegovina', prefix: '387') unless Country.exists?(code: 'ba')
Country.create(code: 'bw', name: 'Botswana', prefix: '267') unless Country.exists?(code: 'bw')
Country.create(code: 'br', name: 'Brazil', prefix: '55') unless Country.exists?(code: 'br')
Country.create(code: 'bn', name: 'Brunei', prefix: '673') unless Country.exists?(code: 'bn')
Country.create(code: 'bg', name: 'Bulgaria', prefix: '359') unless Country.exists?(code: 'bg')
Country.create(code: 'bf', name: 'Burkina Faso', prefix: '226') unless Country.exists?(code: 'bf')
Country.create(code: 'bi', name: 'Burundi', prefix: '257') unless Country.exists?(code: 'bi')
Country.create(code: 'kh', name: 'Cambodia', prefix: '855') unless Country.exists?(code: 'kh')
Country.create(code: 'cm', name: 'Cameroon', prefix: '237') unless Country.exists?(code: 'cm')
Country.create(code: 'ca', name: 'Canada', prefix: '1') unless Country.exists?(code: 'ca')
Country.create(code: 'cv', name: 'Cape Verde', prefix: '238') unless Country.exists?(code: 'cv')
Country.create(code: 'ky', name: 'Cayman Islands', prefix: '1345') unless Country.exists?(code: 'ky')
Country.create(code: 'cf', name: 'Central Africa', prefix: '236') unless Country.exists?(code: 'cf')
Country.create(code: 'td', name: 'Chad', prefix: '235') unless Country.exists?(code: 'td')
Country.create(code: 'cl', name: 'Chile', prefix: '56') unless Country.exists?(code: 'cl')
Country.create(code: 'cn', name: 'China', prefix: '86') unless Country.exists?(code: 'cn')
Country.create(code: 'co', name: 'Colombia', prefix: '57') unless Country.exists?(code: 'co')
Country.create(code: 'km', name: 'Comoros', prefix: '269') unless Country.exists?(code: 'km')
Country.create(code: 'cg', name: 'Congo', prefix: '242') unless Country.exists?(code: 'cg')
Country.create(code: 'cd', name: 'Congo, Dem Rep', prefix: '243') unless Country.exists?(code: 'cd')
Country.create(code: 'cr', name: 'Costa Rica', prefix: '506') unless Country.exists?(code: 'cr')
Country.create(code: 'hr', name: 'Croatia', prefix: '385') unless Country.exists?(code: 'hr')
Country.create(code: 'cy', name: 'Cyprus', prefix: '357') unless Country.exists?(code: 'cy')
Country.create(code: 'cz', name: 'Czech Republic', prefix: '420') unless Country.exists?(code: 'cz')
Country.create(code: 'dk', name: 'Denmark', prefix: '45') unless Country.exists?(code: 'dk')
Country.create(code: 'dj', name: 'Djibouti', prefix: '253') unless Country.exists?(code: 'dj')
Country.create(code: 'dm', name: 'Dominica', prefix: '1767') unless Country.exists?(code: 'dm')
Country.create(code: 'do', name: 'Dominican Republic', prefix: '1809') unless Country.exists?(code: 'do')
Country.create(code: 'eg', name: 'Egypt', prefix: '20') unless Country.exists?(code: 'eg')
Country.create(code: 'sv', name: 'El Salvador', prefix: '503') unless Country.exists?(code: 'sv')
Country.create(code: 'gq', name: 'Equatorial Guinea', prefix: '240') unless Country.exists?(code: 'gq')
Country.create(code: 'ee', name: 'Estonia', prefix: '372') unless Country.exists?(code: 'ee')
Country.create(code: 'et', name: 'Ethiopia', prefix: '251') unless Country.exists?(code: 'et')
Country.create(code: 'fo', name: 'Faroe Islands', prefix: '298') unless Country.exists?(code: 'fo')
Country.create(code: 'fj', name: 'Fiji', prefix: '679') unless Country.exists?(code: 'fj')
Country.create(code: 'fi', name: 'Finland/Aland Islands', prefix: '358') unless Country.exists?(code: 'fi')
Country.create(code: 'fr', name: 'France', prefix: '33') unless Country.exists?(code: 'fr')
Country.create(code: 'gf', name: 'French Guiana', prefix: '594') unless Country.exists?(code: 'gf')
Country.create(code: 'pf', name: 'French Polynesia', prefix: '689') unless Country.exists?(code: 'pf')
Country.create(code: 'ga', name: 'Gabon', prefix: '241') unless Country.exists?(code: 'ga')
Country.create(code: 'gm', name: 'Gambia', prefix: '220') unless Country.exists?(code: 'gm')
Country.create(code: 'ge', name: 'Georgia', prefix: '995') unless Country.exists?(code: 'ge')
Country.create(code: 'de', name: 'Germany', prefix: '49') unless Country.exists?(code: 'de')
Country.create(code: 'gh', name: 'Ghana', prefix: '233') unless Country.exists?(code: 'gh')
Country.create(code: 'gi', name: 'Gibraltar', prefix: '350') unless Country.exists?(code: 'gi')
Country.create(code: 'gr', name: 'Greece', prefix: '30') unless Country.exists?(code: 'gr')
Country.create(code: 'gl', name: 'Greenland', prefix: '299') unless Country.exists?(code: 'gl')
Country.create(code: 'gd', name: 'Grenada', prefix: '1473') unless Country.exists?(code: 'gd')
Country.create(code: 'gp', name: 'Guadeloupe', prefix: '590') unless Country.exists?(code: 'gp')
Country.create(code: 'gu', name: 'Guam', prefix: '1671') unless Country.exists?(code: 'gu')
Country.create(code: 'gt', name: 'Guatemala', prefix: '502') unless Country.exists?(code: 'gt')
Country.create(code: 'gn', name: 'Guinea', prefix: '224') unless Country.exists?(code: 'gn')
Country.create(code: 'gy', name: 'Guyana', prefix: '592') unless Country.exists?(code: 'gy')
Country.create(code: 'ht', name: 'Haiti', prefix: '509') unless Country.exists?(code: 'ht')
Country.create(code: 'hn', name: 'Honduras', prefix: '504') unless Country.exists?(code: 'hn')
Country.create(code: 'hk', name: 'Hong Kong', prefix: '852') unless Country.exists?(code: 'hk')
Country.create(code: 'hu', name: 'Hungary', prefix: '36') unless Country.exists?(code: 'hu')
Country.create(code: 'is', name: 'Iceland', prefix: '354') unless Country.exists?(code: 'is')
Country.create(code: 'in', name: 'India', prefix: '91') unless Country.exists?(code: 'in')
Country.create(code: 'id', name: 'Indonesia', prefix: '62') unless Country.exists?(code: 'id')
Country.create(code: 'ir', name: 'Iran', prefix: '98') unless Country.exists?(code: 'ir')
Country.create(code: 'iq', name: 'Iraq', prefix: '964') unless Country.exists?(code: 'iq')
Country.create(code: 'ie', name: 'Ireland', prefix: '353') unless Country.exists?(code: 'ie')
Country.create(code: 'il', name: 'Israel', prefix: '972') unless Country.exists?(code: 'il')
Country.create(code: 'it', name: 'Italy', prefix: '39') unless Country.exists?(code: 'it')
Country.create(code: 'jm', name: 'Jamaica', prefix: '1876') unless Country.exists?(code: 'jm')
Country.create(code: 'jp', name: 'Japan', prefix: '81') unless Country.exists?(code: 'jp')
Country.create(code: 'jo', name: 'Jordan', prefix: '962') unless Country.exists?(code: 'jo')
Country.create(code: 'ke', name: 'Kenya', prefix: '254') unless Country.exists?(code: 'ke')
Country.create(code: 'kr', name: 'Korea, Republic of', prefix: '82') unless Country.exists?(code: 'kr')
Country.create(code: 'kw', name: 'Kuwait', prefix: '965') unless Country.exists?(code: 'kw')
Country.create(code: 'kg', name: 'Kyrgyzstan', prefix: '996') unless Country.exists?(code: 'kg')
Country.create(code: 'la', name: 'Laos', prefix: '856') unless Country.exists?(code: 'la')
Country.create(code: 'lv', name: 'Latvia', prefix: '371') unless Country.exists?(code: 'lv')
Country.create(code: 'lb', name: 'Lebanon', prefix: '961') unless Country.exists?(code: 'lb')
Country.create(code: 'ls', name: 'Lesotho', prefix: '266') unless Country.exists?(code: 'ls')
Country.create(code: 'lr', name: 'Liberia', prefix: '231') unless Country.exists?(code: 'lr')
Country.create(code: 'ly', name: 'Libya', prefix: '218') unless Country.exists?(code: 'ly')
Country.create(code: 'li', name: 'Liechtenstein', prefix: '423') unless Country.exists?(code: 'li')
Country.create(code: 'lt', name: 'Lithuania', prefix: '370') unless Country.exists?(code: 'lt')
Country.create(code: 'lu', name: 'Luxembourg', prefix: '352') unless Country.exists?(code: 'lu')
Country.create(code: 'mo', name: 'Macao', prefix: '853') unless Country.exists?(code: 'mo')
Country.create(code: 'mk', name: 'Macedonia', prefix: '389') unless Country.exists?(code: 'mk')
Country.create(code: 'mg', name: 'Madagascar', prefix: '261') unless Country.exists?(code: 'mg')
Country.create(code: 'mw', name: 'Malawi', prefix: '265') unless Country.exists?(code: 'mw')
Country.create(code: 'my', name: 'Malaysia', prefix: '60') unless Country.exists?(code: 'my')
Country.create(code: 'mv', name: 'Maldives', prefix: '960') unless Country.exists?(code: 'mv')
Country.create(code: 'ml', name: 'Mali', prefix: '223') unless Country.exists?(code: 'ml')
Country.create(code: 'mt', name: 'Malta', prefix: '356') unless Country.exists?(code: 'mt')
Country.create(code: 'mq', name: 'Martinique', prefix: '596') unless Country.exists?(code: 'mq')
Country.create(code: 'mr', name: 'Mauritania', prefix: '222') unless Country.exists?(code: 'mr')
Country.create(code: 'mu', name: 'Mauritius', prefix: '230') unless Country.exists?(code: 'mu')
Country.create(code: 'mx', name: 'Mexico', prefix: '52') unless Country.exists?(code: 'mx')
Country.create(code: 'mc', name: 'Monaco', prefix: '377') unless Country.exists?(code: 'mc')
Country.create(code: 'mn', name: 'Mongolia', prefix: '976') unless Country.exists?(code: 'mn')
Country.create(code: 'me', name: 'Montenegro', prefix: '382') unless Country.exists?(code: 'me')
Country.create(code: 'ms', name: 'Montserrat', prefix: '1664') unless Country.exists?(code: 'ms')
Country.create(code: 'ma', name: 'Morocco/Western Sahara', prefix: '212') unless Country.exists?(code: 'ma')
Country.create(code: 'mz', name: 'Mozambique', prefix: '258') unless Country.exists?(code: 'mz')
Country.create(code: 'na', name: 'Namibia', prefix: '264') unless Country.exists?(code: 'na')
Country.create(code: 'np', name: 'Nepal', prefix: '977') unless Country.exists?(code: 'np')
Country.create(code: 'nl', name: 'Netherlands', prefix: '31') unless Country.exists?(code: 'nl')
Country.create(code: 'nz', name: 'New Zealand', prefix: '64') unless Country.exists?(code: 'nz')
Country.create(code: 'ni', name: 'Nicaragua', prefix: '505') unless Country.exists?(code: 'ni')
Country.create(code: 'ne', name: 'Niger', prefix: '227') unless Country.exists?(code: 'ne')
Country.create(code: 'ng', name: 'Nigeria', prefix: '234') unless Country.exists?(code: 'ng')
Country.create(code: 'no', name: 'Norway', prefix: '47') unless Country.exists?(code: 'no')
Country.create(code: 'om', name: 'Oman', prefix: '968') unless Country.exists?(code: 'om')
Country.create(code: 'pk', name: 'Pakistan', prefix: '92') unless Country.exists?(code: 'pk')
Country.create(code: 'ps', name: 'Palestinian Territory', prefix: '970') unless Country.exists?(code: 'ps')
Country.create(code: 'pa', name: 'Panama', prefix: '507') unless Country.exists?(code: 'pa')
Country.create(code: 'py', name: 'Paraguay', prefix: '595') unless Country.exists?(code: 'py')
Country.create(code: 'pe', name: 'Peru', prefix: '51') unless Country.exists?(code: 'pe')
Country.create(code: 'ph', name: 'Philippines', prefix: '63') unless Country.exists?(code: 'ph')
Country.create(code: 'pl', name: 'Poland', prefix: '48') unless Country.exists?(code: 'pl')
Country.create(code: 'pt', name: 'Portugal', prefix: '351') unless Country.exists?(code: 'pt')
Country.create(code: 'pr', name: 'Puerto Rico', prefix: '1787') unless Country.exists?(code: 'pr')
Country.create(code: 'qa', name: 'Qatar', prefix: '974') unless Country.exists?(code: 'qa')
Country.create(code: 're', name: 'Reunion/Mayotte', prefix: '262') unless Country.exists?(code: 're')
Country.create(code: 'ro', name: 'Romania', prefix: '40') unless Country.exists?(code: 'ro')
Country.create(code: 'ru', name: 'Russia/Kazakhstan', prefix: '7') unless Country.exists?(code: 'ru')
Country.create(code: 'rw', name: 'Rwanda', prefix: '250') unless Country.exists?(code: 'rw')
Country.create(code: 'ws', name: 'Samoa', prefix: '685') unless Country.exists?(code: 'ws')
Country.create(code: 'sm', name: 'San Marino', prefix: '378') unless Country.exists?(code: 'sm')
Country.create(code: 'sa', name: 'Saudi Arabia', prefix: '966') unless Country.exists?(code: 'sa')
Country.create(code: 'sn', name: 'Senegal', prefix: '221') unless Country.exists?(code: 'sn')
Country.create(code: 'rs', name: 'Serbia', prefix: '381') unless Country.exists?(code: 'rs')
Country.create(code: 'sc', name: 'Seychelles', prefix: '248') unless Country.exists?(code: 'sc')
Country.create(code: 'sl', name: 'Sierra Leone', prefix: '232') unless Country.exists?(code: 'sl')
Country.create(code: 'sg', name: 'Singapore', prefix: '65') unless Country.exists?(code: 'sg')
Country.create(code: 'sk', name: 'Slovakia', prefix: '421') unless Country.exists?(code: 'sk')
Country.create(code: 'si', name: 'Slovenia', prefix: '386') unless Country.exists?(code: 'si')
Country.create(code: 'za', name: 'South Africa', prefix: '27') unless Country.exists?(code: 'za')
Country.create(code: 'es', name: 'Spain', prefix: '34') unless Country.exists?(code: 'es')
Country.create(code: 'lk', name: 'Sri Lanka', prefix: '94') unless Country.exists?(code: 'lk')
Country.create(code: 'kn', name: 'St Kitts and Nevis', prefix: '1869') unless Country.exists?(code: 'kn')
Country.create(code: 'lc', name: 'St Lucia', prefix: '1758') unless Country.exists?(code: 'lc')
Country.create(code: 'vc', name: 'St Vincent Grenadines', prefix: '1784') unless Country.exists?(code: 'vc')
Country.create(code: 'sd', name: 'Sudan', prefix: '249') unless Country.exists?(code: 'sd')
Country.create(code: 'sr', name: 'Suriname', prefix: '597') unless Country.exists?(code: 'sr')
Country.create(code: 'sz', name: 'Swaziland', prefix: '268') unless Country.exists?(code: 'sz')
Country.create(code: 'se', name: 'Sweden', prefix: '46') unless Country.exists?(code: 'se')
Country.create(code: 'ch', name: 'Switzerland', prefix: '41') unless Country.exists?(code: 'ch')
Country.create(code: 'sy', name: 'Syria', prefix: '963') unless Country.exists?(code: 'sy')
Country.create(code: 'tw', name: 'Taiwan', prefix: '886') unless Country.exists?(code: 'tw')
Country.create(code: 'tj', name: 'Tajikistan', prefix: '992') unless Country.exists?(code: 'tj')
Country.create(code: 'tz', name: 'Tanzania', prefix: '255') unless Country.exists?(code: 'tz')
Country.create(code: 'th', name: 'Thailand', prefix: '66') unless Country.exists?(code: 'th')
Country.create(code: 'tg', name: 'Togo', prefix: '228') unless Country.exists?(code: 'tg')
Country.create(code: 'to', name: 'Tonga', prefix: '676') unless Country.exists?(code: 'to')
Country.create(code: 'tt', name: 'Trinidad and Tobago', prefix: '1868') unless Country.exists?(code: 'tt')
Country.create(code: 'tn', name: 'Tunisia', prefix: '216') unless Country.exists?(code: 'tn')
Country.create(code: 'tr', name: 'Turkey', prefix: '90') unless Country.exists?(code: 'tr')
Country.create(code: 'tc', name: 'Turks and Caicos Islands', prefix: '1649') unless Country.exists?(code: 'tc')
Country.create(code: 'ug', name: 'Uganda', prefix: '256') unless Country.exists?(code: 'ug')
Country.create(code: 'ua', name: 'Ukraine', prefix: '380') unless Country.exists?(code: 'ua')
Country.create(code: 'ae', name: 'United Arab Emirates', prefix: '971') unless Country.exists?(code: 'ae')
Country.create(code: 'gb', name: 'United Kingdom', prefix: '44') unless Country.exists?(code: 'gb')
Country.create(code: 'us', name: 'United States', prefix: '1') unless Country.exists?(code: 'us')
Country.create(code: 'uy', name: 'Uruguay', prefix: '598') unless Country.exists?(code: 'uy')
Country.create(code: 'uz', name: 'Uzbekistan', prefix: '998') unless Country.exists?(code: 'uz')
Country.create(code: 've', name: 'Venezuela', prefix: '58') unless Country.exists?(code: 've')
Country.create(code: 'vn', name: 'Vietnam', prefix: '84') unless Country.exists?(code: 'vn')
Country.create(code: 'vg', name: 'Virgin Islands, British', prefix: '1284') unless Country.exists?(code: 'vg')
Country.create(code: 'vi', name: 'Virgin Islands, U.S.', prefix: '1340') unless Country.exists?(code: 'vi')
Country.create(code: 'ye', name: 'Yemen', prefix: '967') unless Country.exists?(code: 'ye')
Country.create(code: 'zm', name: 'Zambia', prefix: '260') unless Country.exists?(code: 'zm')
Country.create(code: 'zw', name: 'Zimbabwe', prefix: '263') unless Country.exists?(code: 'zw')
