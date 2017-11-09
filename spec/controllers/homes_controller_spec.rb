require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  before :each do
    Faq.create!(
        question: 'What services provided WatchIoT?',
        answer: '<mark>WatchIot</mark> is a monitoring service that allows us to know in real time and throw alert to us if our services, resources or devices (IoT) have some behavior that we want to pay attention.',
        lang: 'en')

    Faq.create!(
        question: 'How much costs the service of WatchIoT?',
        answer: '<mark>WatchIot</mark> costs nothing, it is absolutely free.',
        lang: 'en')

    Descrip.create!(
        title: 'Multiplatform',
        description: 'You can monitor several platforms, like <mark>IOS, Windows, Linux, Android, etc</mark> and can even monitor your cloud services or web applications, in addition to devices (Internet of Things) too.',
        icon: 'cubes',
        lang: 'en'
    )

    Descrip.create!(
        title: 'Configurable',
        description: 'The power of <mark>WatchIoT</mark> is that everything is configurable and incredibly simple. You can configure all about how you want to handle your services, resources and devices (IoT) and send alert for many way.',
        icon: 'cog',
        lang: 'en'
    )
  end

  describe 'home index' do
    it 'get home index has a 200 status code, all is ok' do
      get :index
      expect(response.status).to eq(200)
      expect(response).to render_template('index')
      expect(assigns[:faqs]).to_not be_nil
      expect(assigns[:descrips]).to_not be_nil
    end
    
  end
end
