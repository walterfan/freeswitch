## Why

FreeSWITCH developers currently have reference material and repository knowledge, but no guided path that turns those resources into working SIP, WebRTC audio, IVR, observability, and C/C++ extension skills in a predictable period. A 30-day, project-driven tutorial will shorten onboarding by making every concept traceable to source code and a reproducible Ubuntu/Debian Docker lab.

## What Changes

- Add a Chinese-first 30-day curriculum under `tutorial/`, structured so English content can be added later without duplicating labs or code.
- Add a local C++/Crow teaching website that serves the lessons, exposes safe lab checks, streams FreeSWITCH events, and hosts a browser SIP/WebRTC audio client implemented with HTML and JavaScript.
- Add daily theory, source-navigation, guided-lab, challenge, validation, troubleshooting, and bilingual-glossary sections.
- Add a capstone call path from a browser over SIP/WSS and WebRTC audio through FreeSWITCH to a SIP softphone or multi-level IVR.
- Add an out-of-tree teaching module that demonstrates FreeSWITCH module lifecycle, a custom dialplan application, an API, channel variables, custom events, counters, logging, and tests without adding configuration to `conf/vanilla`.
- Add an ESL-based C++ observer that consumes core and tutorial events, reports health, and exports Prometheus-format metrics derived from `status`, `HEARTBEAT`, call events, CDRs, and the teaching module.
- Add Docker-oriented deployment assets, certificate guidance, automated checks, and a final reproducibility checklist while treating the existing `man/` PKB as the source-navigation reference.

## Capabilities

### New Capabilities

- `freeswitch-tutorial/curriculum`: Defines the Chinese-first 30-day learning path, daily lesson contract, shared lab assets, progression, and completion outcomes.
- `freeswitch-tutorial/web-app`: Defines the C++/Crow teaching site, lesson navigation, browser SIP/WebRTC softphone, event display, and safe lab validation experience.
- `freeswitch-tutorial/module-development`: Defines the teaching-oriented FreeSWITCH C module and the behaviors learners implement, load, observe, and test.
- `freeswitch-tutorial/observability`: Defines ESL collection, health reporting, call and IVR metrics, Prometheus exposition, degradation behavior, and troubleshooting signals.

### Modified Capabilities

None.

## Impact

- Adds a new top-level `tutorial/` tree containing curriculum, labs, a C++17/Crow service, browser assets, a teaching module, deployment files, and tests.
- Introduces tutorial-only dependencies such as CMake, Conan, Crow, a pinned local browser SIP library, and optional Prometheus; these do not become FreeSWITCH runtime dependencies.
- Integrates with FreeSWITCH through SIP over WSS, WebRTC media, XML dialplan assets kept under `tutorial/`, ESL, custom events, CDRs, and an out-of-tree loadable module.
- Uses the existing Ubuntu/Debian Docker lab and `man/` documentation as prerequisites; existing FreeSWITCH core behavior and `conf/vanilla` remain unchanged.
- Exposes local tutorial HTTP/SSE and Prometheus endpoints. ESL credentials remain server-side, remote microphone use requires trusted HTTPS/WSS, and validation APIs are restricted to predefined read-only checks.
