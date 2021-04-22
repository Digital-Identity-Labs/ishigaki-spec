control "java_version" do
  impact 1.0
  title "Amazon Corretto Java is installed correctly"
  desc "Default OpenJDK Java should not be used: either Amazon Corretto Java or Oracle Java should be installed"

  describe apt('https://apt.corretto.aws') do
    it { should exist }
    it { should be_enabled }
  end

  describe package('java-11-amazon-corretto-jdk') do
    it { should be_installed }
    its('version') { should match /^1:11/ }
  end

  describe file('/usr/lib/jvm/java-11-amazon-corretto') do
    it {should exist}
  end

  describe package('openjdk-8-jdk') do
    it { should_not be_installed }
  end

  describe package('openjdk-11-jdk') do
    it { should_not be_installed }
  end

  describe os_env('JAVA_HOME') do
    its('content') { should eq "/usr/lib/jvm/java-11-amazon-corretto" }
  end

  describe command('java -version') do
    its('stderr') { should include 'openjdk version "11' }
    its('stderr') { should include 'Corretto' }
    its('stderr') { should include 'OpenJDK 64-Bit Server VM' }
    its('exit_status') { should eq 0 }
  end

end