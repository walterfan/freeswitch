## Context

See `proposal.md` for motivation and the four delta specs for observable behavior. The repository already contains an English/Chinese PKB under `man/`, a documented Ubuntu/Debian Docker lab, `mod_sofia` WS/WSS bindings, `mod_verto`, ESL libraries, and a standalone-module template under `build/standalone_module/`. It does not contain a `tutorial/` tree, a browser SIP client, or a first-party Prometheus exporter.

The tutorial must help developers learn FreeSWITCH quickly while still reaching source-level C/C++ extension work. That creates two constraints: the website cannot consume most of the course, and the browser media path must remain a real FreeSWITCH call rather than a simulation. Existing user changes in the Docker and `man/` areas are prerequisites to reference, not files for this change to replace.

## Goals / Non-Goals

**Goals:**

- Deliver one coherent system that grows across 30 lessons instead of 30 unrelated demos.
- Keep browser audio on a standards-based SIP/WSS and WebRTC path terminated by FreeSWITCH.
- Use C/C++ for both in-process module development and the out-of-process teaching service.
- Make every lesson verifiable through commands, source references, safe automated checks, or an explicit manual media check.
- Preserve a clean boundary between reusable curriculum content, the teaching website, FreeSWITCH lab assets, and production FreeSWITCH code.

**Non-Goals:**

- A production PBX, SBC, hosted learning platform, multi-user account system, or production monitoring distribution.
- Video, PSTN trunking, TURN service deployment, speech recognition, text-to-speech, or mobile browser certification.
- Replacing the Users Manual or duplicating its parameter tables.
- Modifying FreeSWITCH core behavior or adding tutorial configuration to `conf/vanilla`.
- Completing the English translation in the first release.
- Allowing the website to execute arbitrary shell, file, dialplan, or ESL commands.

## Decisions

### 1. Use a project-driven spiral

The course expands one call system in six phases. This gives learners a working result every few days while revisiting signaling, media, configuration, source, control, and observability at increasing depth.

| Days | Phase | Main outcome |
|---|---|---|
| 1-5 | FreeSWITCH foundations | Run the lab, register two SIP users, complete and inspect a SIP-to-SIP call |
| 6-10 | SIP and media | Explain and diagnose REGISTER, INVITE, SDP, RTP, codecs, NAT, and hangup behavior |
| 11-15 | WebRTC audio | Register the browser over WSS and bridge bidirectional browser audio to a SIP softphone |
| 16-20 | IVR and ESL | Build a multi-level DTMF IVR and observe/control its calls through ESL |
| 21-25 | C/C++ module development | Build, load, invoke, inspect, and test `mod_tutorial` |
| 26-30 | Metrics and capstone | Export health/call/IVR metrics and demonstrate the complete system |

The detailed lesson allocation is:

1. FreeSWITCH system model, tutorial site, and first health check.
2. Docker process, paths, ports, logs, and `fs_cli`.
3. Loadable modules and build-time versus runtime module selection.
4. XML configuration, directory, dialplan, and variable expansion.
5. Register users 1000/1001, make the first call, and trace its UUID.
6. SIP messages and transaction/dialog mental model.
7. REGISTER digest authentication and directory lookup source path.
8. INVITE routing, contexts, dialplan hunt, and bridge source path.
9. SDP, RTP, DTMF, and codec negotiation.
10. NAT, advertised addresses, packet capture, and one-way-audio diagnosis.
11. Browser media permissions, secure contexts, and audio devices.
12. SIP over WS/WSS and trusted local certificates.
13. WebRTC SDP, ICE, DTLS-SRTP, and Opus.
14. Browser-to-SIP bridging, codec selection, and transcoding evidence.
15. WebRTC troubleshooting lab covering WSS, registration, ICE, and audio.
16. Playback, recording, phrase macros, and sound-file requirements.
17. DTMF collection, timeouts, invalid input, and XML IVR construction.
18. Multi-level IVR routing and channel variables.
19. ESL authentication, command/reply, events, and call correlation.
20. A small C++ ESL client that follows the browser-to-IVR call.
21. FreeSWITCH module interface, lifecycle, memory pools, and standalone build.
22. Implement and test the `tutorial_metrics` API.
23. Implement the `tutorial_ivr_metric` dialplan application and channel variables.
24. Emit `tutorial::ivr_choice`, add bounded counters, and handle concurrency.
25. Load/unload, failure handling, logging, integration tests, and source debugging.
26. Native `status`, `HEARTBEAT`, channel events, CDRs, and metric semantics.
27. Build the C++ ESL collector and consistent in-memory snapshots.
28. Expose `/metrics`, health, bounded labels, and outage/staleness behavior.
29. Integrate the website event/Metrics panels and execute failure drills.
30. Run the capstone, final acceptance checklist, and next-step source map.

Alternative considered: teach protocol theory, configuration, and code in separate blocks. It produces a cleaner reference taxonomy but delays a working WebRTC call and makes the course feel less cumulative. Independent daily challenges were rejected because they do not create a meaningful capstone.

### 2. Use C++/Crow plus a native browser frontend

The teaching service will use C++17, Crow, CMake, and Conan, following the local `csms-test-service` layout. It serves static content and JSON/SSE/Prometheus endpoints. The frontend uses HTML, CSS, and JavaScript without a Node-based application build. A fixed, locally served SIP.js browser bundle and its license notice provide SIP user-agent behavior.

This option aligns backend work with the course's C/C++ goal and lets the ESL collector become a useful teaching artifact. Deno would reduce website implementation effort and has excellent WebSocket/npm support, but would add a second primary server language. Streamlit is useful for dashboards, but its rerun/component state model adds an unnecessary Python/JavaScript boundary around a long-lived SIP/WebRTC client.

The website service is not a media proxy and does not implement SIP signaling. Those remain browser-to-FreeSWITCH responsibilities.

### 3. Organize `tutorial/` by stable responsibilities

```text
tutorial/
├── README.md
├── content/
│   └── zh-CN/
│       ├── syllabus.md
│       └── days/day-01.md ... day-30.md
├── site/
│   ├── CMakeLists.txt
│   ├── conanfile.py
│   ├── include/
│   ├── src/
│   ├── config/
│   └── web/
├── module/mod_tutorial/
├── labs/day-01/ ... day-30/
├── deploy/
└── tests/
```

Lesson Markdown owns explanation and links. `labs/` owns executable snippets, XML, packet fixtures, and starter code shared by locales. `site/` owns presentation and external observation. `module/` owns the standalone FreeSWITCH extension. `deploy/` owns only tutorial-specific Compose overlays, local certificate instructions, and optional Prometheus configuration.

A small content manifest maps stable lesson IDs to locale files, title, phase, prerequisites, and declared validation checks. Browser progress is keyed by lesson ID in local storage. SIP passwords stay in memory for the current page session and are not persisted as progress.

### 4. Keep the media and control planes separate

```text
Browser HTML/JS
  ├── SIP/WSS + WebRTC audio ──> mod_sofia ──> FreeSWITCH ──> SIP/RTP phone or IVR
  └── HTTP + SSE ──────────────> C++ teaching service ──> ESL command/event sockets
                                                     └──> Prometheus scrape endpoint
```

The primary browser path is SIP over WSS through the internal Sofia profile because the course emphasizes both WebRTC audio and SIP. Verto is introduced as an alternative endpoint in source navigation but is not the capstone signaling protocol. The browser negotiates WebRTC media with FreeSWITCH, which terminates DTLS-SRTP and bridges or transcodes to the SIP leg.

Localhost HTTP may be used for the browser secure-context exception. Any access through another hostname or address requires trusted HTTPS for the teaching site and trusted WSS for FreeSWITCH. The course documents certificates explicitly; it does not bypass browser certificate validation.

### 5. Define a narrow teaching-service API

The initial HTTP contract is versioned:

| Endpoint | Purpose |
|---|---|
| `GET /api/v1/health` | Component health, freshness, and safe remediation hints |
| `GET /api/v1/public-config` | WSS URL, SIP domain, tutorial extensions, and non-secret UI defaults |
| `GET /api/v1/events` | Server-Sent Events for bounded, sanitized runtime evidence |
| `POST /api/v1/checks/{lesson-id}/{check-id}` | Execute one declared, argument-free or schema-bounded lab check |
| `GET /metrics` | Prometheus text exposition |
| `GET /content/...` and static routes | Lessons and browser assets |

SSE is preferred to a teaching-service WebSocket because runtime evidence is server-to-browser and automatic reconnection is useful. SIP signaling still uses its own direct WebSocket connection to FreeSWITCH.

Checks are registered in code by stable ID and call typed functions. They do not accept command strings or arbitrary paths. A check can inspect a configured file, query a fixed health endpoint, or issue an allowlisted read-only FreeSWITCH API through the command connection. Check output is normalized to `pass`, `fail`, or `unavailable`, with evidence and remediation.

### 6. Use separate ESL event and command connections

The service links against the repository's ESL library. One dedicated connection and reader thread owns event subscription and receive operations. A second serialized connection handles bounded `api` requests such as `status`, `sofia status`, and the teaching module's read-only API. Separating them prevents asynchronous events from confusing command/reply handling.

The event client subscribes only to HEARTBEAT, relevant channel lifecycle/bridge/hangup events, and `tutorial::ivr_choice`. It converts headers into a small internal event model, redacts and allowlists fields, sends observations to the Metrics registry, and appends display events to a bounded ring buffer. Slow SSE clients receive a drop notification and a fresh snapshot instead of applying backpressure to ESL.

Connection state is a state machine: disconnected, connecting, authenticating, subscribed, and degraded. Reconnect uses configurable exponential backoff with a bounded maximum and resets after a stable connection. Lesson delivery and static assets do not depend on ESL readiness.

### 7. Build Metrics from documented FreeSWITCH signals

The repository has no `mod_prometheus`, so the course starts with `status`, the default HEARTBEAT event, channel events, and CDRs before adding exposition. A Metrics registry produces immutable snapshots for both the website and `/metrics`.

Required metric families follow the observability spec. Call-result labels use a bounded normalization such as `answered`, `busy`, `no_answer`, `rejected`, and `failed`; raw hangup causes remain event evidence rather than labels. IVR menu and choice labels are accepted only from configured tutorial menus, with unexpected values collapsed to `other`. Session UUIDs, users, IPs, and phone numbers are never metric labels.

HEARTBEAT supplies capacity and freshness. Channel create/destroy events maintain live observations. A per-call correlation record ensures completion and duration are counted once, then expires from a bounded cache. CDR evidence can reconcile completed calls but must not double-count an already finalized correlation record. During an outage, `freeswitch_up` and `freeswitch_esl_connected` become zero and freshness exposes stale state; last-known session values are not represented as current.

### 8. Implement `mod_tutorial` as a standalone teaching module

The module follows `build/standalone_module/` and the installed `freeswitch.pc` contract rather than adding itself to `build/modules.conf.in`. Its tutorial XML and dialplan remain under `tutorial/` and are mounted or copied into the lab explicitly.

The module registers:

- API `tutorial_metrics [text|json]`, which returns version, module uptime, invocation totals, invalid totals, and bounded per-choice counts without mutation.
- Application `tutorial_ivr_metric <menu> <choice>`, which validates configured menu/choice pairs, sets `tutorial_ivr_menu`, `tutorial_ivr_choice`, and `tutorial_ivr_recorded`, increments counters, and emits `CUSTOM tutorial::ivr_choice` with a session correlation ID.

Counter state is protected by a FreeSWITCH synchronization primitive and copied into a consistent snapshot before formatting. Menu/choice keys come from bounded tutorial configuration to prevent unbounded memory and label cardinality. Load registers the event subclass and interfaces only after configuration and synchronization initialization succeed. Shutdown refuses unsafe teardown according to FreeSWITCH lifecycle conventions, frees the event subclass, and destroys owned resources in reverse order.

### 9. Make content and code independently testable

Verification is layered:

- A content validator checks exactly 30 lesson IDs, required sections, locale manifest consistency, relative links, referenced files, and forbidden placeholders.
- CTest covers service configuration, check registry allowlisting, event redaction, ring-buffer bounds, call correlation, metric formatting, and outage snapshots.
- Module tests use the repository test conventions and `src/include/test/switch_test.h` where the FreeSWITCH test harness is required; pure parsing/formatting helpers remain independently testable.
- HTTP smoke tests cover static content, health, rejection of unknown checks, SSE content type, and Prometheus parsing.
- A Docker integration test covers service startup, ESL reconnect, module load/API, event receipt, and IVR metric export.
- Browser/SIP acceptance covers microphone permission, WSS registration, two-way audio, DTMF, and hangup. Audio perception remains an explicit manual check; signaling and state transitions can be automated separately.

Every lesson validation states whether it is automatic, semi-automatic, or manual and never reports an unperformed media observation as passed.

### 10. Default to an isolated local deployment

Tutorial Compose assets extend the existing FreeSWITCH lab rather than replacing it. The teaching service container publishes its HTTP port to loopback by default and reaches ESL through the lab network or a loopback-scoped mapping. FreeSWITCH SIP/WSS and RTP exposure follow the existing lab documentation. Prometheus is optional and scrapes only the teaching service.

Secrets are injected through environment or a local ignored configuration file. Public configuration excludes passwords. Logs redact SIP authorization, digest nonce, private keys, SDP, IPs, phone numbers, and full UUIDs by default. Diagnostic lessons may show sensitive protocol fields locally, but the text instructs learners to sanitize captures before sharing and to turn tracing off.

## Risks / Trade-offs

- **[C++ website work distracts from FreeSWITCH]** → Ship a functioning service skeleton early and defer its internal implementation lessons to days 20 and 26-29.
- **[Browser certificate setup blocks WebRTC]** → Provide a preflight page, explicit localhost versus remote rules, trusted-certificate instructions, and stage-specific diagnostics before the first WSS lesson.
- **[Docker/NAT differences cause one-way audio]** → Use the existing documented Ubuntu/Debian host-network baseline, make advertised addresses visible, and dedicate days 10 and 15 to packet-based diagnosis.
- **[SIP.js or browser changes break examples]** → Pin and serve the browser SIP dependency locally, record tested browser versions, isolate it behind a small frontend adapter, and include a registration/call smoke scenario.
- **[ESL event bursts or slow browsers grow memory]** → Use bounded queues, bounded correlation retention, drop counters, and snapshots for reconnecting SSE clients.
- **[Metrics double-count or create high cardinality]** → Normalize finite labels, keep per-call finalization state, expire correlations, and test replay/duplicate events.
- **[Tutorial code is copied into production]** → Mark the entire deployment as educational, bind locally by default, remove default credentials from public responses, and document production non-goals in the landing page.
- **[Thirty lessons drift from source]** → Make source links and validation commands part of the lesson contract and add content checks that fail on missing paths and placeholders.

## Migration Plan

1. Add the tutorial skeleton, content manifest, build entry points, and content validator without altering existing runtime configuration.
2. Add the C++ service with static lessons, health, public configuration, and safe check registry.
3. Add the browser SIP adapter and establish the WebRTC-to-SIP lab path.
4. Add the separate ESL connections, sanitized SSE feed, correlation model, and Metrics registry.
5. Add and test the standalone `mod_tutorial`, then mount its tutorial-only dialplan/config in the lab.
6. Author and validate the six curriculum phases against the working cumulative system.
7. Add optional Prometheus deployment, outage drills, capstone automation, and the manual audio acceptance checklist.

Rollback is removal of the `tutorial/` deployment and artifacts. No FreeSWITCH schema or production configuration migration is required; the lab unloads `mod_tutorial` and removes only tutorial-mounted XML and generated tutorial data.
