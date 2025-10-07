import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Simplified schedule store for Android
class ScheduleStore {
  static final ScheduleStore _instance = ScheduleStore._internal();
  factory ScheduleStore() => _instance;
  ScheduleStore._internal();

  static const String _tasksKey = 'farm_tasks';
  static const String _schedulesKey = 'farm_schedules';

  List<FarmTask> _tasks = [];
  List<FarmSchedule> _schedules = [];

  List<FarmTask> get tasks => List.unmodifiable(_tasks);
  List<FarmSchedule> get schedules => List.unmodifiable(_schedules);

  // Initialize and load data
  Future<void> init() async {
    await _loadTasks();
    await _loadSchedules();
  }

  // Task Management
  Future<void> addTask(FarmTask task) async {
    _tasks.add(task);
    await _saveTasks();
    print('Task added: ${task.title}');
  }

  Future<void> updateTask(FarmTask updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      await _saveTasks();
      print('Task updated: ${updatedTask.title}');
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks();
    print('Task deleted: $taskId');
  }

  Future<void> markTaskComplete(String taskId) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        status: TaskStatus.completed,
        completedAt: DateTime.now(),
      );
      await _saveTasks();
      print('Task completed: ${_tasks[index].title}');
    }
  }

  // Get tasks by status
  List<FarmTask> getTasksByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  // Get tasks due today
  List<FarmTask> getTasksDueToday() {
    final today = DateTime.now();
    return _tasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.year == today.year &&
          task.dueDate!.month == today.month &&
          task.dueDate!.day == today.day &&
          task.status != TaskStatus.completed;
    }).toList();
  }

  // Get overdue tasks
  List<FarmTask> getOverdueTasks() {
    final now = DateTime.now();
    return _tasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.isBefore(now) && task.status != TaskStatus.completed;
    }).toList();
  }

  // Quick add methods for common farming tasks
  Future<void> addWateringTask({
    required String plantName,
    required DateTime dueDate,
    String? notes,
  }) async {
    final task = FarmTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Water $plantName',
      description: 'Water the $plantName plants',
      type: TaskType.watering,
      dueDate: dueDate,
      priority: TaskPriority.high,
      notes: notes,
    );
    await addTask(task);
  }

  // Private methods
  Future<void> _loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_tasksKey);
      if (tasksJson != null) {
        final List<dynamic> tasksList = json.decode(tasksJson);
        _tasks = tasksList.map((json) => FarmTask.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading tasks: $e');
      _tasks = [];
    }
  }

  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = json.encode(_tasks.map((task) => task.toJson()).toList());
      await prefs.setString(_tasksKey, tasksJson);
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  Future<void> _loadSchedules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final schedulesJson = prefs.getString(_schedulesKey);
      if (schedulesJson != null) {
        final List<dynamic> schedulesList = json.decode(schedulesJson);
        _schedules = schedulesList.map((json) => FarmSchedule.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading schedules: $e');
      _schedules = [];
    }
  }
}

// Data models
class FarmTask {
  final String id;
  final String title;
  final String description;
  final TaskType type;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final String? notes;
  final DateTime createdAt;

  FarmTask({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.status = TaskStatus.pending,
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.completedAt,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  FarmTask copyWith({
    String? title,
    String? description,
    TaskType? type,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    DateTime? completedAt,
    String? notes,
  }) {
    return FarmTask(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type.index,
    'status': status.index,
    'priority': priority.index,
    'dueDate': dueDate?.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory FarmTask.fromJson(Map<String, dynamic> json) => FarmTask(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    type: TaskType.values[json['type']],
    status: TaskStatus.values[json['status']],
    priority: TaskPriority.values[json['priority']],
    dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    notes: json['notes'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class FarmSchedule {
  final String id;
  final String title;
  final String description;
  final ScheduleType type;
  final ScheduleFrequency frequency;
  final DateTime time;
  final bool isActive;
  final DateTime createdAt;

  FarmSchedule({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.frequency,
    required this.time,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type.index,
    'frequency': frequency.index,
    'time': time.toIso8601String(),
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
  };

  factory FarmSchedule.fromJson(Map<String, dynamic> json) => FarmSchedule(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    type: ScheduleType.values[json['type']],
    frequency: ScheduleFrequency.values[json['frequency']],
    time: DateTime.parse(json['time']),
    isActive: json['isActive'] ?? true,
    createdAt: DateTime.parse(json['createdAt']),
  );
}

// Enums
enum TaskType {
  watering,
  fertilizing,
  pestControl,
  harvesting,
  planting,
  pruning,
  soilTesting,
  other,
}

enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}

enum TaskPriority {
  low,
  medium,
  high,
  urgent,
}

enum ScheduleType {
  watering,
  fertilizing,
  pestControl,
  inspection,
  maintenance,
  other,
}

enum ScheduleFrequency {
  daily,
  weekly,
  monthly,
}