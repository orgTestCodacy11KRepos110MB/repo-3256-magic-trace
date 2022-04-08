(** Backends, which do the Processor Trace recording, present this unified
    interface in order to be exposed as commands which can generate traces. *)

open! Core
open! Async

module type S = sig
  module Record_opts : sig
    type t

    val param : t Command.Param.t
  end

  module Recording : sig
    type t

    val attach_and_record
      :  Record_opts.t
      -> debug_print_perf_commands:bool
      -> when_to_snapshot:When_to_snapshot.t
      -> trace_mode:Trace_mode.t
      -> timer_resolution:Timer_resolution.t
      -> record_dir:string
      -> Pid.t
      -> t Deferred.Or_error.t

    val take_snapshot : t -> unit Or_error.t
    val finish_recording : t -> unit Deferred.Or_error.t
  end

  module Decode_opts : sig
    type t

    val param : t Command.Param.t
  end

  val decode_events
    :  Decode_opts.t
    -> debug_print_perf_commands:bool
    -> record_dir:string
    -> perf_map:Perf_map.t option
    -> Decode_result.t Deferred.Or_error.t
end
