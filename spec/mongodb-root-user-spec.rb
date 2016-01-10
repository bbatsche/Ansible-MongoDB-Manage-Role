require_relative 'spec_helper'

RSpec.configure do |config|
  config.before :suite do
    SpecHelper.instance.provision('playbooks/mongodb-manage.yml', {
      new_mongodb_user: 'root_user',
      new_mongodb_pass: 'password'
    })
  end
end

describe command("mongo -u root_user -p password admin --eval 'db.system.users.find({_id: \"admin.root_user\"}).count()'") do
  its(:stdout) { should match /connecting to: admin/ }
  its(:stdout) { should match /^1$/ }

  its(:exit_status) { should eq 0}
end
