defmodule ExFacts.System.CPUTest do
  use ExUnit.Case, async: true
  import ExFacts.System.CPU
  doctest ExFacts.System.CPU

  test "CPU.counts/0" do
    {cpus, 0} = System.cmd "nproc", []
    cpus =
      cpus
      |> String.replace("\n", "")
      |> String.to_integer

    assert cpus == counts()
  end

  test "CPU.counts/0 returns an integer" do
    assert is_integer(counts())
  end

  test "CPU.cpu_info/0" do
    {:ok, data} = {:ok, [%ExFacts.System.CPU.InfoStat{cache_size: 2048, core_id: "0", cores: 2, cpu: 0,
   family: "21",
   flags: ["fpu", "vme", "de", "pse", "tsc", "msr", "pae", "mce", "cx8", "apic",
    "sep", "mtrr", "pge", "mca", "cmov", "pat", "pse36", "clflush", "mmx",
    "fxsr", "sse", "sse2", "ht", "syscall", "nx", "mmxext", "fxsr_opt",
    "pdpe1gb", "rdtscp", "lm", "constant_tsc", "rep_good", "nopl",
    "nonstop_tsc", "extd_apicid", "aperfmperf", "pni", "pclmulqdq", "monitor",
    "ssse3", "cx16", "sse4_1", "sse4_2", "popcnt", "aes", "xsave", "avx", "lahf_lm",
    "cmp_legacy", "svm", "extapic", "cr8_legacy", "abm", "sse4a", "misalignsse",
    "3dnowprefetch", "osvw", "ibs", "xop", "skinit", "wdt", "lwp", "fma4",
    "nodeid_msr", "topoext", "perfctr_core", "perfctr_nb", "cpb", "hw_pstate",
    "vmmcall", "arat", "npt", "lbrv", "svm_lock", "nrip_save", "tsc_scale",
    "vmcb_clean", "flushbyasid", "decodeassists", "pausefilter", "pfthreshold"],
   mhz: 1.4, microcode: "0x600063d",
   model: "1", model_name: "AMD FX(tm)-4100 Quad-Core Processor",
   physical_id: "0", stepping: 2, vendor_id: "AuthenticAMD"},
  %ExFacts.System.CPU.InfoStat{cache_size: 2048, core_id: "1", cores: 2, cpu: 1,
   family: "21",
   flags: ["fpu", "vme", "de", "pse", "tsc", "msr", "pae", "mce", "cx8", "apic",
    "sep", "mtrr", "pge", "mca", "cmov", "pat", "pse36", "clflush", "mmx",
    "fxsr", "sse", "sse2", "ht", "syscall", "nx", "mmxext", "fxsr_opt",
    "pdpe1gb", "rdtscp", "lm", "constant_tsc", "rep_good", "nopl",
    "nonstop_tsc", "extd_apicid", "aperfmperf", "pni", "pclmulqdq", "monitor",
    "ssse3", "cx16", "sse4_1", "sse4_2", "popcnt", "aes", "xsave", "avx", "lahf_lm",
    "cmp_legacy", "svm", "extapic", "cr8_legacy", "abm", "sse4a", "misalignsse",
    "3dnowprefetch", "osvw", "ibs", "xop", "skinit", "wdt", "lwp", "fma4",
    "nodeid_msr", "topoext", "perfctr_core", "perfctr_nb", "cpb", "hw_pstate",
    "vmmcall", "arat", "npt", "lbrv", "svm_lock", "nrip_save", "tsc_scale",
    "vmcb_clean", "flushbyasid", "decodeassists", "pausefilter", "pfthreshold"],
   mhz: 1.4, microcode: "0x600063d", model: "1",
   model_name: "AMD FX(tm)-4100 Quad-Core Processor", physical_id: "0",
   stepping: 2, vendor_id: "AuthenticAMD"},
  %ExFacts.System.CPU.InfoStat{cache_size: 2048, core_id: "2", cores: 2, cpu: 2,
   family: "21",
   flags: ["fpu", "vme", "de", "pse", "tsc", "msr", "pae", "mce", "cx8", "apic",
    "sep", "mtrr", "pge", "mca", "cmov", "pat", "pse36", "clflush", "mmx",
    "fxsr", "sse", "sse2", "ht", "syscall", "nx", "mmxext", "fxsr_opt",
    "pdpe1gb", "rdtscp", "lm", "constant_tsc", "rep_good", "nopl",
    "nonstop_tsc", "extd_apicid", "aperfmperf", "pni", "pclmulqdq", "monitor",
    "ssse3", "cx16", "sse4_1", "sse4_2", "popcnt", "aes", "xsave", "avx", "lahf_lm",
    "cmp_legacy", "svm", "extapic", "cr8_legacy", "abm", "sse4a", "misalignsse",
    "3dnowprefetch", "osvw", "ibs", "xop", "skinit", "wdt", "lwp", "fma4",
    "nodeid_msr", "topoext", "perfctr_core", "perfctr_nb", "cpb", "hw_pstate",
    "vmmcall", "arat", "npt", "lbrv", "svm_lock", "nrip_save", "tsc_scale",
    "vmcb_clean", "flushbyasid", "decodeassists", "pausefilter", "pfthreshold"],
   mhz: 1.4, microcode: "0x600063d", model: "1",
   model_name: "AMD FX(tm)-4100 Quad-Core Processor", physical_id: "0",
   stepping: 2, vendor_id: "AuthenticAMD"},
  %ExFacts.System.CPU.InfoStat{cache_size: 2048, core_id: "3", cores: 2, cpu: 3,
   family: "21",
   flags: ["fpu", "vme", "de", "pse", "tsc", "msr", "pae", "mce", "cx8", "apic",
    "sep", "mtrr", "pge", "mca", "cmov", "pat", "pse36", "clflush", "mmx",
    "fxsr", "sse", "sse2", "ht", "syscall", "nx", "mmxext", "fxsr_opt",
    "pdpe1gb", "rdtscp", "lm", "constant_tsc", "rep_good", "nopl",
    "nonstop_tsc", "extd_apicid", "aperfmperf", "pni", "pclmulqdq", "monitor",
    "ssse3", "cx16", "sse4_1", "sse4_2", "popcnt", "aes", "xsave", "avx", "lahf_lm",
    "cmp_legacy", "svm", "extapic", "cr8_legacy", "abm", "sse4a", "misalignsse",
    "3dnowprefetch", "osvw", "ibs", "xop", "skinit", "wdt", "lwp", "fma4",
    "nodeid_msr", "topoext", "perfctr_core", "perfctr_nb", "cpb", "hw_pstate",
    "vmmcall", "arat", "npt", "lbrv", "svm_lock", "nrip_save", "tsc_scale",
    "vmcb_clean", "flushbyasid", "decodeassists", "pausefilter", "pfthreshold"],
   mhz: 1.4, microcode: "0x600063d", model: "1",
   model_name: "AMD FX(tm)-4100 Quad-Core Processor", physical_id: "0",
   stepping: 2, vendor_id: "AuthenticAMD"}]}

   {:ok, return} = cpu_info()

   # Unfortunately each call to cpu_info/0 can generate a different
   # MHz value so we must hack that for the tests

   hdata =
     data
     |> Enum.map(fn x -> Map.put(x, :mhz, 1) end)

   hreturn =
     return
     |> Enum.map(fn x -> Map.put(x, :mhz, 1) end)

   assert hdata == hreturn
  end

end
