require 'rails_helper'
require 'securerandom'

RSpec.describe UserRegistration, type: :service do
  let(:auth_hash) {
    {
      provider: 'dev',
      uid: '12345',
      info: { name: 'John McFoo' }
    }.stringify_keys
  }

  subject { described_class.new(auth_hash) }

  it { expect { described_class.new }.to raise_error(ArgumentError) }

  it { is_expected.to be_created }

  describe 'user' do
    it { expect(subject.user).to be_a(User) }
  end

  context 'when the user already exists' do
    before { subject.user }

    it { expect(described_class.new(auth_hash)).to_not be_created }
  end
end
