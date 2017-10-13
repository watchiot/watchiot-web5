# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create plans static values
freePlan = Plan.create(name: 'Free', amount_per_month: 0) unless Plan.exists?(name: 'Free')
hobbyPlan = Plan.create(name: 'Hobby', amount_per_month: 7) unless Plan.exists?(name: 'Hobby')
professionalPlan = Plan.create(name: 'Professional', amount_per_month: 29) unless Plan.exists?(name: 'Professional')

amountSpaceFeature = Feature.create(name: 'Amount of spaces') unless Feature.exists?(name: 'Amount of spaces')
amountOfProjectBySpaceFeature = Feature.create(name: 'Amount of projects by space') unless Feature.exists?(name: 'Amount of projects by space')
amountOfMetricsByProjectFeature = Feature.create(name: 'Amount of metrics by project') unless Feature.exists?(name: 'Amount of metrics by project')
dataRetentionFeature = Feature.create(name: 'Data retention') unless Feature.exists?(name: 'Data retention')
requestPerHourFeature = Feature.create(name: 'Request per hours for each project') unless Feature.exists?(name: 'Request per hours for each project')
teamMembersFeature = Feature.create(name: 'Team members') unless Feature.exists?(name: 'Team members')
amountOfStatesFeature = Feature.create(name: 'Amount of states') unless Feature.exists?(name: 'Amount of states')

# Amount of spaces
PlanFeature.create(plan_id: freePlan.id, feature_id: amountSpaceFeature.id, value: '2')
PlanFeature.create(plan_id: hobbyPlan.id, feature_id: amountSpaceFeature.id, value: '4')
PlanFeature.create(plan_id: professionalPlan.id, feature_id: amountSpaceFeature.id, value: '30')

# Amount of projects by space
PlanFeature.create(plan_id: freePlan.id, feature_id: amountOfProjectBySpaceFeature.id, value: '3')
PlanFeature.create(plan_id: hobbyPlan.id, feature_id: amountOfProjectBySpaceFeature.id, value: '5')
PlanFeature.create(plan_id: professionalPlan.id, feature_id: amountOfProjectBySpaceFeature.id, value: '30')

# Amount of metrics by project
PlanFeature.create(plan_id: freePlan.id, feature_id: amountOfMetricsByProjectFeature.id, value: '3')
PlanFeature.create(plan_id: hobbyPlan.id, feature_id: amountOfMetricsByProjectFeature.id, value: '6')
PlanFeature.create(plan_id: professionalPlan.id, feature_id: amountOfMetricsByProjectFeature.id, value: 'unlimited')

# Data retention
PlanFeature.create(plan_id: freePlan.id, feature_id: dataRetentionFeature.id, value: '7')
PlanFeature.create(plan_id: hobbyPlan.id, feature_id: dataRetentionFeature.id, value: '60')
PlanFeature.create(plan_id: professionalPlan.id, feature_id: dataRetentionFeature.id, value: '360')

# Request per hours per project
PlanFeature.create(plan_id: freePlan.id, feature_id: requestPerHourFeature.id, value: '60')
PlanFeature.create(plan_id: hobbyPlan.id, feature_id: requestPerHourFeature.id, value: '360')
PlanFeature.create(plan_id: professionalPlan.id, feature_id: requestPerHourFeature.id, value: '3600')

# Team members
PlanFeature.create(plan_id: freePlan.id, feature_id: teamMembersFeature.id, value: '2')
PlanFeature.create(plan_id: hobbyPlan.id, feature_id: teamMembersFeature.id, value: '5')
PlanFeature.create(plan_id: professionalPlan.id, feature_id: teamMembersFeature.id, value: 'unlimited')

# Amount of states
PlanFeature.create(plan_id: freePlan.id, feature_id: amountOfStatesFeature.id, value: '3')
PlanFeature.create(plan_id: hobbyPlan.id, feature_id: amountOfStatesFeature.id, value: '5')
PlanFeature.create(plan_id: professionalPlan.id, feature_id: amountOfStatesFeature.id, value: 'unlimited')

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
    answer: 'You have the ability to invite friends to help you manage spaces and projects, and receive alerts too. '\
            'You have a maximum of 2 invite friends, if you require more please contact us.',
    lang: 'en')

Faq.create(
    question: 'Puedo agregar amigos para que administren mis espacios y proyectos',
    answer: 'Usted tiene la posibilidad de invitar amigos a que le ayuden a administrar los espacios y proyectos, adem&aacute;s '\
            'de recibir alertas. Usted tiene un m&aacute;ximo de invitar dos amigos. Si usted requiere m&aacute;s '\
            'por favor p&oacute;ngase en contacto con nosotros.',
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

# Countries
Country.create(code: 'af', name: 'Afghanistan', prefix: '93')
Country.create(code: 'al', name: 'Albania', prefix: '355')
Country.create(code: 'dz', name: 'Algeria', prefix: '213')
Country.create(code: 'as', name: 'American Samoa', prefix: '1684')
Country.create(code: 'ad', name: 'Andorra', prefix: '376')
Country.create(code: 'ao', name: 'Angola', prefix: '244')
Country.create(code: 'ai', name: 'Anguilla', prefix: '1264')
Country.create(code: 'ag', name: 'Antigua and Barbuda', prefix: '1268')
Country.create(code: 'ar', name: 'Argentina', prefix: '54')
Country.create(code: 'am', name: 'Armenia', prefix: '374')
Country.create(code: 'aw', name: 'Aruba', prefix: '297')
Country.create(code: 'au', name: 'Australia/Cocos/Christmas Island', prefix: '61')
Country.create(code: 'at', name: 'Austria', prefix: '43')
Country.create(code: 'az', name: 'Azerbaijan', prefix: '994')
Country.create(code: 'bs', name: 'Bahamas', prefix: '1')
Country.create(code: 'bh', name: 'Bahrain', prefix: '973')
Country.create(code: 'bd', name: 'Bangladesh', prefix: '880')
Country.create(code: 'bb', name: 'Barbados', prefix: '1246')
Country.create(code: 'by', name: 'Belarus', prefix: '375')
Country.create(code: 'be', name: 'Belgium', prefix: '32')
Country.create(code: 'bz', name: 'Belize', prefix: '501')
Country.create(code: 'bj', name: 'Benin', prefix: '229')
Country.create(code: 'bm', name: 'Bermuda', prefix: '1441')
Country.create(code: 'bo', name: 'Bolivia', prefix: '591')
Country.create(code: 'ba', name: 'Bosnia and Herzegovina', prefix: '387')
Country.create(code: 'bw', name: 'Botswana', prefix: '267')
Country.create(code: 'br', name: 'Brazil', prefix: '55')
Country.create(code: 'bn', name: 'Brunei', prefix: '673')
Country.create(code: 'bg', name: 'Bulgaria', prefix: '359')
Country.create(code: 'bf', name: 'Burkina Faso', prefix: '226')
Country.create(code: 'bi', name: 'Burundi', prefix: '257')
Country.create(code: 'kh', name: 'Cambodia', prefix: '855')
Country.create(code: 'cm', name: 'Cameroon', prefix: '237')
Country.create(code: 'ca', name: 'Canada', prefix: '1')
Country.create(code: 'cv', name: 'Cape Verde', prefix: '238')
Country.create(code: 'ky', name: 'Cayman Islands', prefix: '1345')
Country.create(code: 'cf', name: 'Central Africa', prefix: '236')
Country.create(code: 'td', name: 'Chad', prefix: '235')
Country.create(code: 'cl', name: 'Chile', prefix: '56')
Country.create(code: 'cn', name: 'China', prefix: '86')
Country.create(code: 'co', name: 'Colombia', prefix: '57')
Country.create(code: 'km', name: 'Comoros', prefix: '269')
Country.create(code: 'cg', name: 'Congo', prefix: '242')
Country.create(code: 'cd', name: 'Congo, Dem Rep', prefix: '243')
Country.create(code: 'cr', name: 'Costa Rica', prefix: '506')
Country.create(code: 'hr', name: 'Croatia', prefix: '385')
Country.create(code: 'cy', name: 'Cyprus', prefix: '357')
Country.create(code: 'cz', name: 'Czech Republic', prefix: '420')
Country.create(code: 'dk', name: 'Denmark', prefix: '45')
Country.create(code: 'dj', name: 'Djibouti', prefix: '253')
Country.create(code: 'dm', name: 'Dominica', prefix: '1767')
Country.create(code: 'do', name: 'Dominican Republic', prefix: '1809')
Country.create(code: 'eg', name: 'Egypt', prefix: '20')
Country.create(code: 'sv', name: 'El Salvador', prefix: '503')
Country.create(code: 'gq', name: 'Equatorial Guinea', prefix: '240')
Country.create(code: 'ee', name: 'Estonia', prefix: '372')
Country.create(code: 'et', name: 'Ethiopia', prefix: '251')
Country.create(code: 'fo', name: 'Faroe Islands', prefix: '298')
Country.create(code: 'fj', name: 'Fiji', prefix: '679')
Country.create(code: 'fi', name: 'Finland/Aland Islands', prefix: '358')
Country.create(code: 'fr', name: 'France', prefix: '33')
Country.create(code: 'gf', name: 'French Guiana', prefix: '594')
Country.create(code: 'pf', name: 'French Polynesia', prefix: '689')
Country.create(code: 'ga', name: 'Gabon', prefix: '241')
Country.create(code: 'gm', name: 'Gambia', prefix: '220')
Country.create(code: 'ge', name: 'Georgia', prefix: '995')
Country.create(code: 'de', name: 'Germany', prefix: '49')
Country.create(code: 'gh', name: 'Ghana', prefix: '233')
Country.create(code: 'gi', name: 'Gibraltar', prefix: '350')
Country.create(code: 'gr', name: 'Greece', prefix: '30')
Country.create(code: 'gl', name: 'Greenland', prefix: '299')
Country.create(code: 'gd', name: 'Grenada', prefix: '1473')
Country.create(code: 'gp', name: 'Guadeloupe', prefix: '590')
Country.create(code: 'gu', name: 'Guam', prefix: '1671')
Country.create(code: 'gt', name: 'Guatemala', prefix: '502')
Country.create(code: 'gn', name: 'Guinea', prefix: '224')
Country.create(code: 'gy', name: 'Guyana', prefix: '592')
Country.create(code: 'ht', name: 'Haiti', prefix: '509')
Country.create(code: 'hn', name: 'Honduras', prefix: '504')
Country.create(code: 'hk', name: 'Hong Kong', prefix: '852')
Country.create(code: 'hu', name: 'Hungary', prefix: '36')
Country.create(code: 'is', name: 'Iceland', prefix: '354')
Country.create(code: 'in', name: 'India', prefix: '91')
Country.create(code: 'id', name: 'Indonesia', prefix: '62')
Country.create(code: 'ir', name: 'Iran', prefix: '98')
Country.create(code: 'iq', name: 'Iraq', prefix: '964')
Country.create(code: 'ie', name: 'Ireland', prefix: '353')
Country.create(code: 'il', name: 'Israel', prefix: '972')
Country.create(code: 'it', name: 'Italy', prefix: '39')
Country.create(code: 'jm', name: 'Jamaica', prefix: '1876')
Country.create(code: 'jp', name: 'Japan', prefix: '81')
Country.create(code: 'jo', name: 'Jordan', prefix: '962')
Country.create(code: 'ke', name: 'Kenya', prefix: '254')
Country.create(code: 'kr', name: 'Korea, Republic of', prefix: '82')
Country.create(code: 'kw', name: 'Kuwait', prefix: '965')
Country.create(code: 'kg', name: 'Kyrgyzstan', prefix: '996')
Country.create(code: 'la', name: 'Laos', prefix: '856')
Country.create(code: 'lv', name: 'Latvia', prefix: '371')
Country.create(code: 'lb', name: 'Lebanon', prefix: '961')
Country.create(code: 'ls', name: 'Lesotho', prefix: '266')
Country.create(code: 'lr', name: 'Liberia', prefix: '231')
Country.create(code: 'ly', name: 'Libya', prefix: '218')
Country.create(code: 'li', name: 'Liechtenstein', prefix: '423')
Country.create(code: 'lt', name: 'Lithuania', prefix: '370')
Country.create(code: 'lu', name: 'Luxembourg', prefix: '352')
Country.create(code: 'mo', name: 'Macao', prefix: '853')
Country.create(code: 'mk', name: 'Macedonia', prefix: '389')
Country.create(code: 'mg', name: 'Madagascar', prefix: '261')
Country.create(code: 'mw', name: 'Malawi', prefix: '265')
Country.create(code: 'my', name: 'Malaysia', prefix: '60')
Country.create(code: 'mv', name: 'Maldives', prefix: '960')
Country.create(code: 'ml', name: 'Mali', prefix: '223')
Country.create(code: 'mt', name: 'Malta', prefix: '356')
Country.create(code: 'mq', name: 'Martinique', prefix: '596')
Country.create(code: 'mr', name: 'Mauritania', prefix: '222')
Country.create(code: 'mu', name: 'Mauritius', prefix: '230')
Country.create(code: 'mx', name: 'Mexico', prefix: '52')
Country.create(code: 'mc', name: 'Monaco', prefix: '377')
Country.create(code: 'mn', name: 'Mongolia', prefix: '976')
Country.create(code: 'me', name: 'Montenegro', prefix: '382')
Country.create(code: 'ms', name: 'Montserrat', prefix: '1664')
Country.create(code: 'ma', name: 'Morocco/Western Sahara', prefix: '212')
Country.create(code: 'mz', name: 'Mozambique', prefix: '258')
Country.create(code: 'na', name: 'Namibia', prefix: '264')
Country.create(code: 'np', name: 'Nepal', prefix: '977')
Country.create(code: 'nl', name: 'Netherlands', prefix: '31')
Country.create(code: 'nz', name: 'New Zealand', prefix: '64')
Country.create(code: 'ni', name: 'Nicaragua', prefix: '505')
Country.create(code: 'ne', name: 'Niger', prefix: '227')
Country.create(code: 'ng', name: 'Nigeria', prefix: '234')
Country.create(code: 'no', name: 'Norway', prefix: '47')
Country.create(code: 'om', name: 'Oman', prefix: '968')
Country.create(code: 'pk', name: 'Pakistan', prefix: '92')
Country.create(code: 'ps', name: 'Palestinian Territory', prefix: '970')
Country.create(code: 'pa', name: 'Panama', prefix: '507')
Country.create(code: 'py', name: 'Paraguay', prefix: '595')
Country.create(code: 'pe', name: 'Peru', prefix: '51')
Country.create(code: 'ph', name: 'Philippines', prefix: '63')
Country.create(code: 'pl', name: 'Poland', prefix: '48')
Country.create(code: 'pt', name: 'Portugal', prefix: '351')
Country.create(code: 'pr', name: 'Puerto Rico', prefix: '1787')
Country.create(code: 'qa', name: 'Qatar', prefix: '974')
Country.create(code: 're', name: 'Reunion/Mayotte', prefix: '262')
Country.create(code: 'ro', name: 'Romania', prefix: '40')
Country.create(code: 'ru', name: 'Russia/Kazakhstan', prefix: '7')
Country.create(code: 'rw', name: 'Rwanda', prefix: '250')
Country.create(code: 'ws', name: 'Samoa', prefix: '685')
Country.create(code: 'sm', name: 'San Marino', prefix: '378')
Country.create(code: 'sa', name: 'Saudi Arabia', prefix: '966')
Country.create(code: 'sn', name: 'Senegal', prefix: '221')
Country.create(code: 'rs', name: 'Serbia', prefix: '381')
Country.create(code: 'sc', name: 'Seychelles', prefix: '248')
Country.create(code: 'sl', name: 'Sierra Leone', prefix: '232')
Country.create(code: 'sg', name: 'Singapore', prefix: '65')
Country.create(code: 'sk', name: 'Slovakia', prefix: '421')
Country.create(code: 'si', name: 'Slovenia', prefix: '386')
Country.create(code: 'za', name: 'South Africa', prefix: '27')
Country.create(code: 'es', name: 'Spain', prefix: '34')
Country.create(code: 'lk', name: 'Sri Lanka', prefix: '94')
Country.create(code: 'kn', name: 'St Kitts and Nevis', prefix: '1869')
Country.create(code: 'lc', name: 'St Lucia', prefix: '1758')
Country.create(code: 'vc', name: 'St Vincent Grenadines', prefix: '1784')
Country.create(code: 'sd', name: 'Sudan', prefix: '249')
Country.create(code: 'sr', name: 'Suriname', prefix: '597')
Country.create(code: 'sz', name: 'Swaziland', prefix: '268')
Country.create(code: 'se', name: 'Sweden', prefix: '46')
Country.create(code: 'ch', name: 'Switzerland', prefix: '41')
Country.create(code: 'sy', name: 'Syria', prefix: '963')
Country.create(code: 'tw', name: 'Taiwan', prefix: '886')
Country.create(code: 'tj', name: 'Tajikistan', prefix: '992')
Country.create(code: 'tz', name: 'Tanzania', prefix: '255')
Country.create(code: 'th', name: 'Thailand', prefix: '66')
Country.create(code: 'tg', name: 'Togo', prefix: '228')
Country.create(code: 'to', name: 'Tonga', prefix: '676')
Country.create(code: 'tt', name: 'Trinidad and Tobago', prefix: '1868')
Country.create(code: 'tn', name: 'Tunisia', prefix: '216')
Country.create(code: 'tr', name: 'Turkey', prefix: '90')
Country.create(code: 'tc', name: 'Turks and Caicos Islands', prefix: '1649')
Country.create(code: 'ug', name: 'Uganda', prefix: '256')
Country.create(code: 'ua', name: 'Ukraine', prefix: '380')
Country.create(code: 'ae', name: 'United Arab Emirates', prefix: '971')
Country.create(code: 'gb', name: 'United Kingdom', prefix: '44')
Country.create(code: 'us', name: 'United States', prefix: '1')
Country.create(code: 'uy', name: 'Uruguay', prefix: '598')
Country.create(code: 'uz', name: 'Uzbekistan', prefix: '998')
Country.create(code: 've', name: 'Venezuela', prefix: '58')
Country.create(code: 'vn', name: 'Vietnam', prefix: '84')
Country.create(code: 'vg', name: 'Virgin Islands, British', prefix: '1284')
Country.create(code: 'vi', name: 'Virgin Islands, U.S.', prefix: '1340')
Country.create(code: 'ye', name: 'Yemen', prefix: '967')
Country.create(code: 'zm', name: 'Zambia', prefix: '260')
Country.create(code: 'zw', name: 'Zimbabwe', prefix: '263')
