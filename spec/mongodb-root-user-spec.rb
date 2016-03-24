require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook("playbooks/mongodb-manage.yml", {
      new_db_user: "root_user",
      new_db_pass: "password"
    })
  end
end

describe command("mongo -u root_user -p password admin --eval 'db.system.users.find({_id: \"admin.root_user\"}).count()'") do
  its(:stdout) { should match /connecting to: admin/ }
  its(:stdout) { should match /^1$/ }

  its(:exit_status) { should eq 0}
end
