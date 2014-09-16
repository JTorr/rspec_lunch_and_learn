require 'car'
require 'spec_helper'

describe Car do
  # Lets are better than instance variables because they use lazy
  # evaluation and provide for better readability. Also note
  # how use of the previously defined data inside another let keeps
  # us from having to redefine the format of args over and over again.
  # We only have to change the interior data.

  let(:make)  { 'ford' }
  let(:model) { 'focus' }
  let(:trim)  { 'xl' }
  let(:color) { 'blue' }
  let(:price) { 100 }
  let(:args) do
    { make: make, model: model, trim: trim,
      color: color, price: price }
  end

  describe '::new' do
    # Contexts provide clear separation of what state
    # your data is in when testing.
    context 'when no arguments are passed' do
      # Use of its methods and subject makes it easy to test return
      # values of methods. Note we didnt have to define subject here
      # because our describing of a class on line 4 set the subject
      # as an instance of that class
      its(:make)  { should == nil }
      its(:model) { should == nil }
      its(:trim)  { should == nil }
      its(:color) { should == nil }
      its(:price) { should == 0 }
    end

    context 'when arguments are passed' do
      # We must define subject in order to get an instance
      # with passed arguments
      subject { Car.new(args) }

      # Meta short hand for repeated tests. USE WITH CAUTION
      # its(:syntax) { should_not be hard_to_read }
      # ^ see what I did there :)
      # Note the use of __send__ instead of send. Always do this
      # to avoid collisions with a self defined send method
      [:make, :model, :trim, :color, :price].each do |field|
        its(field) { should == __send__(field) }
      end

      # Standard long hand version of the above

      # its(:make)  { should == make }
      # its(:model) { should == model }
      # its(:trim)  { should == trim }
      # its(:color) { should == color }
      # its(:price) { should == price }
    end
  end

  describe '.create' do
    # We must define the subject explicitly here in order
    # to set the subject as the class instead of an instance
    subject { Car }

    # There is an rspec matcher for almost anything you could
    # want to do and using them makes the code easier to read
    its(:create) { should be_an_instance_of Car }
  end

  describe '#fuel_types' do
    subject { Car.new(args) }

    # Contexts provide scoping for data changes. Note how the model
    # definition is reused in sub contexts
    context 'when model is focus' do
      let(:model) { 'focus' }

      context 'and the color is blue' do
        let(:color) { 'blue' }
        its(:available_fuel_type) { should eq :smurf_berries }
      end

      context 'and the color is red' do
        let(:color) { 'red' }
        its(:available_fuel_type) { should eq :flex }
      end
    end

    context 'when model is mustang' do
      let(:model) { 'mustang' }

      context 'and the color is red' do
        let(:color) { 'red' }
        its(:available_fuel_type) { should eq :rocket_fuel }
      end
    end
  end

  # In an OO language its pretty much impossible to avoid
  # methods with side effects completely (You should still try).
  # Its in these cases that stubing in unit tests becomes unavoidable
  # (This is part of why you should still try to avoid side effects).
  # In these cases use of the its method becomes cumbersome or imposible
  # and you should probably just use an it 'should ...' line. Note
  # that we can still make effective use of subject.
  describe '#create_side_effect' do
    subject { Car.new(args) }

    context 'when the color is blue' do
      let(:color) { 'blue' }

      it 'should create side effect 1' do
        expect(SideEffecter).to receive(:create_side_effect_1)
        subject.create_side_effect
      end
    end

    context 'when the color is red' do
      let(:color) { 'red' }

      it 'should create side effect 2' do
        expect(SideEffecter).to receive(:create_side_effect_2)
        subject.create_side_effect
      end
    end
  end
end

# A parting word. Youll notice we used no before blocks in this spec
# at all. This is ideal but not practical in a real world example. In
# practice you should use them just like lets to dry up your tests, but
# try to avoid defining data in them. Mostly only stubs should go there
# and occasionaly repeated actions when subjects dont make sense and your
# action can come before your expectation
#
# Thanks for reading. Hope this helps you to love testing more.

