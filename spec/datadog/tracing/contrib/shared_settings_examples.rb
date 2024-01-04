RSpec.shared_examples_for 'with on_error setting' do
  context 'default without settings' do
    subject { described_class.new }

    it { expect(subject.on_error).to be_nil }
  end

  context 'when given a Proc' do
    subject { described_class.new(on_error: proc {}) }

    it { expect(subject.on_error).to be_a(Proc) }
  end

  context 'when given a object of wrong type' do
    subject { described_class.new(on_error: 1) }

    it { expect { subject }.to raise_error(ArgumentError) }

    context 'when skip configuration validation' do
      around do |example|
        ClimateControl.modify('DD_EXPERIMENTAL_SKIP_CONFIGURATION_VALIDATION' => 'true') do
          example.run
        end
      end

      it { expect { subject }.not_to raise_error }
    end
  end
end

RSpec.shared_examples_for 'with error_status_codes setting' do |env:|
  context 'default without settings' do
    subject { described_class.new }

    it { expect(subject.error_status_codes).to eq(400...600) }
  end

  context 'when configured with environment variable' do
    subject { described_class.new }

    context 'when given a single value' do
      around do |example|
        ClimateControl.modify(env => '500') do
          example.run
        end
      end

      it { expect(subject.error_status_codes).to eq(['500']) }
    end

    context 'when given a comma separated list' do
      around do |example|
        ClimateControl.modify(env => '400,500') do
          example.run
        end
      end

      it { expect(subject.error_status_codes).to eq(['400', '500']) }
    end

    context 'when given a comma separated list with space' do
      around do |example|
        ClimateControl.modify(env => '400,,500') do
          example.run
        end
      end

      it { expect(subject.error_status_codes).to eq(['400', '500']) }
    end
  end
end