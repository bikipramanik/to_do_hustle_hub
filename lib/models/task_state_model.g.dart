// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_state_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskStateModelAdapter extends TypeAdapter<TaskStateModel> {
  @override
  final int typeId = 2;

  @override
  TaskStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskStateModel(
      sections: (fields[0] as List).cast<SectionModel>(),
      selectedIndex: fields[1] as int,
      starWhileAddingTask: fields[2] as bool,
      addDescriptionWhileAddingTask: fields[3] as bool,
      showCompletedTask: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TaskStateModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.sections)
      ..writeByte(1)
      ..write(obj.selectedIndex)
      ..writeByte(2)
      ..write(obj.starWhileAddingTask)
      ..writeByte(3)
      ..write(obj.addDescriptionWhileAddingTask)
      ..writeByte(4)
      ..write(obj.showCompletedTask);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskStateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
