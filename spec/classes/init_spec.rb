require 'spec_helper'
describe 'te_axon' do
  context 'with required parameters' do
    let(:params) { {:package_source => ''} }
    it { should contain_class('te_axon') }
  end
end
