/// SDK-only transversal domain primitives, mapping, dates and execution utilities.
///
/// Import this entrypoint to share nominal types across consumers. Infrastructure
/// and vertical business models belong to consumers or separately scoped packages.
library;

export 'src/clock_policy.dart' show ClockPolicy;
export 'src/date_time_iso_utils.dart' show DateTimeIsoUtils;
export 'src/date_utils.dart' show DateUtils, JocaDateUtils;
export 'src/debouncer.dart' show Debouncer;
export 'src/either.dart' show Either, FutureEitherExtensions, Left, Right;
export 'src/entity_util.dart' show EntityUtil;
export 'src/error_item.dart' show ErrorItem, ErrorItemEnum, ErrorLevelEnum;
export 'src/mapper.dart' show Mapper;
export 'src/model.dart' show Model;
export 'src/model_language.dart' show ModelLanguage;
export 'src/model_localized_text.dart' show ModelLocalizedText;
export 'src/model_utils.dart' show ModelUtils;
export 'src/no_params.dart' show NoParams;
export 'src/per_key_fifo_executor.dart' show PerKeyFifoExecutor;
export 'src/unit.dart' show Unit, unit;
export 'src/utils.dart' show Utils;
