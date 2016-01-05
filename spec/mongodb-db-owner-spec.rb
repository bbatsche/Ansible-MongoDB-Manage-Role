require_relative 'spec_helper'

RSpec.configure do |config|
  config.before :suite do
    SpecHelper.instance.provision('playbooks/mongodb-manage.yml', {
      new_mongodb_user: 'db_owner',
      new_mongodb_pass: 'password',
      mongodb_roles:    'dbOwner',
      db_name:          'test_db'
    })
  end
end

describe command("mongo -u vagrant -p vagrant admin --eval 'db.system.users.find({_id: \"test_db.db_owner\"}).count()'") do
  its(:stdout) { should match /^1$/ }
end

describe command("mongo -u db_owner -p password test_db --eval 'db.stats()'") do
  its(:stdout) { should match /connecting to: test_db/ }
  its(:stdout) { should match /"db" : "test_db"/ }
  its(:stdout) { should match /"ok" : 1/ }

  its(:exit_status) { should eq 0}
end

describe command("mongo -u db_owner -p password admin") do
  its(:stdout) { should match /connecting to: admin/ }
  its(:stderr) { should match /exception: login failed/ }

  its(:exit_status) { should_not eq 0}
end
