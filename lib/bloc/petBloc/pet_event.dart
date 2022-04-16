part of 'pet_bloc.dart';

abstract class PetEvent extends Equatable{
  const PetEvent();

  @override
  List<Object> get props => [];
}

class LoadPet extends PetEvent{}

class CreatingPet extends PetEvent{}

class UpdatePet extends PetEvent{
  final List<Pet> pets;

  UpdatePet(this.pets);

  @override
  List<Object> get props => [pets];
}

class AddPet extends PetEvent {
  final Pet pet;

  const AddPet(this.pet);

  @override
  List<Object> get props => [pet];

  @override
  String toString() => 'Add Pet { record: $pet }';
}

class DeletePet extends PetEvent{
  final Pet pet;

  DeletePet(this.pet);

  @override
  List<Object> get props => [pet];
}