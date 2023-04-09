import 'package:fstate_annotation/fstate_annotation.dart';
import 'package:source_gen/source_gen.dart';

TypeChecker fstateAnnotationChecker = TypeChecker.fromRuntime(Fstate);

TypeChecker fconstructorAnnotationChecker =
    TypeChecker.fromRuntime(Fconstructor);

TypeChecker finjectAnnotationChecker = TypeChecker.fromRuntime(Finject);

TypeChecker ftransformAnnotationChecker = TypeChecker.fromRuntime(Ftransform);

TypeChecker factionAnnotationChecker = TypeChecker.fromRuntime(Faction);

TypeChecker fwidgetAnnotationChecker = TypeChecker.fromRuntime(Fwidget);
