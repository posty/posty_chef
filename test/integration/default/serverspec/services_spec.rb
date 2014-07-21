require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end


describe "mysql" do

  it "is listening on port 3306 (MYSQL)" do
    expect(port(3306)).to be_listening
  end

end

describe "postfix" do

  it "is listening on port 25 (SMTP)" do
    expect(port(25)).to be_listening
  end
  it "is listening on port 587 (SMTP)" do
    expect(port(587)).to be_listening
  end

end

describe "dovecot" do

  it "is listening on port 143 (IMAP)" do
    expect(port(143)).to be_listening
  end
  it "is listening on port 993 (IMAPS)" do
    expect(port(993)).to be_listening
  end
  it "is listening on port 110 (POP3)" do
    expect(port(110)).to be_listening
  end
  it "is listening on port 995 (POP3S)" do
    expect(port(995)).to be_listening
  end

end

describe "apache" do

  it "is listening on port 80 (HTTP)" do
    expect(port(80)).to be_listening
  end
  it "is listening on port 443 (HTTPS)" do
    expect(port(443)).to be_listening
  end

end
