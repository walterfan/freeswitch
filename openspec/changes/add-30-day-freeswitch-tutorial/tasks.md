## 1. Tutorial Foundation

- [x] 1.1 Create the `tutorial/` responsibility-based directory skeleton and landing README with educational-use and security boundaries; verify every directory and entry link described by the design exists.
- [x] 1.2 Define the locale-neutral lesson manifest with 30 stable lesson IDs, phases, prerequisites, asset references, and declared check IDs; verify schema tests reject missing, duplicate, out-of-order, and unknown IDs.
- [x] 1.3 Add the Chinese daily lesson template with all required curriculum sections and validation modes; verify the content validator rejects an empty required section and a forbidden placeholder.
- [x] 1.4 Implement the content validator for lesson count, headings, locale mapping, relative links, repository paths, lab assets, and placeholders; verify positive and negative validator fixtures pass.
- [x] 1.5 Add tutorial build and test entry points that do not alter FreeSWITCH runtime dependencies; verify a clean configure/build can discover the site, module, content, and test targets.

## 2. C++ Teaching Service

- [x] 2.1 Scaffold the C++17 Crow service with CMake, Conan, headers, sources, web assets, configuration, and CTest wiring; verify the service binary and initial unit-test binary build in the supported container.
- [x] 2.2 Implement typed configuration for HTTP bind, content root, public SIP defaults, ESL connection, retention bounds, and secrets; verify invalid ports, missing secret sources, and unsafe public binds fail with non-secret errors.
- [x] 2.3 Implement static asset and locale content routes with path sanitization, Chinese fallback, MIME types, and cache behavior; verify traversal attempts fail and a missing English lesson returns the Chinese lesson with fallback metadata.
- [x] 2.4 Implement `GET /api/v1/public-config` with only WSS URL, SIP domain, tutorial extensions, locale, and safe defaults; verify response tests prove ESL and SIP passwords are absent.
- [x] 2.5 Implement component-aware `GET /api/v1/health` for service, content, FreeSWITCH, ESL, heartbeat, SIP profile, and Metrics freshness; verify healthy, degraded, stale, and unavailable snapshots serialize distinctly.
- [x] 2.6 Implement the typed lab-check registry and `POST /api/v1/checks/{lesson-id}/{check-id}` result contract; verify unknown IDs, command-shaped input, and arbitrary paths are rejected without execution.
- [x] 2.7 Add service logging with sensitive-field redaction and safe correlation identifiers; verify tests cover SIP authorization, nonce, password, private-key, IP, number, SDP, and UUID redaction.
- [x] 2.8 Add HTTP smoke tests for landing content, locale fallback, public configuration, health, unknown checks, and unavailable dependencies; verify the smoke suite passes against a running service.

## 3. Curriculum Website

- [x] 3.1 Build the native HTML/CSS/JavaScript application shell with course map, phase navigation, lesson reader, and responsive panels; verify all 30 manifest lessons are reachable without a frontend build step.
- [x] 3.2 Implement browser-local progress keyed by stable lesson ID and locale-independent completion state; verify progress survives reload and does not contain SIP credentials.
- [x] 3.3 Render lesson Markdown and code blocks using pinned local browser assets with third-party license notices; verify the site works with network access disabled after startup.
- [x] 3.4 Add environment preflight and degraded-state UI for site health, FreeSWITCH, ESL, heartbeat, SIP profile, microphone, secure context, and WSS; verify each simulated failure maps to an actionable stage-specific message.
- [x] 3.5 Add the lesson check UI for pass, fail, and unavailable results with evidence and remediation; verify it can invoke only check IDs declared by the active lesson.
- [x] 3.6 Add bounded live-event and Metrics panels that remain usable while lesson content is open; verify rendering drops old UI rows at the configured limit and reports dropped evidence.

## 4. Browser SIP/WebRTC Client

- [x] 4.1 Add a pinned, locally served SIP.js browser bundle, adapter boundary, and license record; verify its hash/version is deterministic and no CDN request is required.
- [x] 4.2 Implement the SIP adapter state model for idle, connecting, registering, registered, incoming, ringing, established, terminating, terminated, and failed; verify state-transition tests reject invalid transitions.
- [x] 4.3 Implement microphone permission, input/output device enumeration, device selection, and remote-audio attachment; verify denial, missing device, and successful selection paths are distinguishable.
- [x] 4.4 Implement WSS connection and SIP digest registration using credentials held only in page memory; verify successful registration and confirm password and authorization data are absent from storage, URLs, logs, and service requests.
- [ ] 4.5 Implement outbound and inbound audio call handling, answer, hangup, remote stream attachment, and status display; verify signaling state with a test adapter and complete a manual two-way-audio check against FreeSWITCH.
- [ ] 4.6 Implement RFC 2833-compatible DTMF sending through the SIP/WebRTC session; verify digits select every documented tutorial IVR branch.
- [x] 4.7 Add diagnostics for secure context, certificate trust, WSS transport, SIP authentication, SDP negotiation, ICE, DTLS-SRTP, codec, and no-audio failures; verify fixture errors map to the documented troubleshooting steps.
- [x] 4.8 Add the browser-to-SIP acceptance checklist covering registration, ringing, bidirectional audio, DTMF, hangup, and cleanup; verify the checklist records manual audio separately from automated signaling evidence.

## 5. ESL Events and Commands

- [x] 5.1 Link the teaching service to the repository ESL client library through explicit build configuration; verify configure fails clearly when ESL headers or library are unavailable and succeeds in the supported lab.
- [x] 5.2 Implement the event-connection state machine, authentication, minimal subscriptions, dedicated reader ownership, and bounded reconnect backoff; verify disconnect, authentication failure, resubscription, and recovery tests pass.
- [x] 5.3 Implement a separate serialized command connection with an internal allowlist for `status`, SIP profile status, and `tutorial_metrics`; verify arbitrary API names and concurrent unsynchronized requests are rejected.
- [x] 5.4 Normalize subscribed FreeSWITCH events into the internal event model and allowlist display fields; verify raw SDP, authorization, credentials, private keys, IPs, numbers, and full UUIDs never reach the normalized object.
- [x] 5.5 Implement the bounded recent-event ring and per-client delivery queues; verify overflow increments drop counters and cannot grow memory beyond configured limits.
- [x] 5.6 Implement `GET /api/v1/events` as SSE with initial snapshot, keepalive, ordered delivery, reconnect behavior, and drop notifications; verify content type, event ordering, and slow-client isolation.
- [x] 5.7 Add typed read-only checks backed by the ESL command connection for status, Sofia profile, registration, module presence, and module API output; verify each returns pass, fail, or unavailable with sanitized evidence.

## 6. Metrics and Health

- [x] 6.1 Implement immutable Metrics snapshots and required counter, gauge, and duration types; verify concurrent readers never observe a partially updated snapshot.
- [x] 6.2 Parse HEARTBEAT and `status` evidence into availability, session, total-session, capacity, and freshness observations; verify malformed or missing headers produce degraded evidence rather than fabricated zero values.
- [x] 6.3 Implement bounded per-call correlation for create, answer, bridge, hangup, and CDR completion; verify duplicate, reordered, missing, and replayed events count each completed call and duration at most once.
- [x] 6.4 Normalize call results into the finite `answered`, `busy`, `no_answer`, `rejected`, and `failed` label set; verify raw hangup causes, UUIDs, users, IPs, and numbers cannot become labels.
- [x] 6.5 Consume `tutorial::ivr_choice` using a configured menu/choice allowlist and `other` fallback; verify unexpected values cannot increase label cardinality.
- [x] 6.6 Implement Prometheus exposition for every metric family required by the observability spec, with HELP/TYPE records and the correct content type; verify a Prometheus parser accepts healthy output.
- [x] 6.7 Implement outage semantics where availability becomes zero, heartbeat age increases, and last-known sessions are marked stale rather than current; verify scrape and health fixtures for FreeSWITCH and ESL outages.
- [x] 6.8 Integrate Metrics summaries into the website without using the browser as the source of truth; verify reload and multiple browser sessions observe consistent server snapshots.

## 7. `mod_tutorial` and IVR

- [x] 7.1 Scaffold `tutorial/module/mod_tutorial/` from the repository standalone-module contract and installed `freeswitch.pc`; verify it builds independently and does not change `build/modules.conf.in` or `conf/vanilla`.
- [x] 7.2 Implement bounded tutorial menu/choice configuration and validation; verify unknown menus, invalid DTMF, malformed configuration, and excessive keys fail safely.
- [x] 7.3 Implement module load and shutdown ordering for configuration, synchronization, event subclass, API, and application interfaces; verify load failure cleans partial resources and load/unload does not stop FreeSWITCH.
- [x] 7.4 Implement the read-only `tutorial_metrics [text|json]` API with consistent snapshots and usage errors; verify both formats contain version, uptime, invocation, invalid, and per-choice counts without mutation.
- [x] 7.5 Implement `tutorial_ivr_metric <menu> <choice>` validation, counters, and channel variables; verify valid input records once and invalid input leaves the channel safe without incrementing a choice.
- [x] 7.6 Emit `CUSTOM tutorial::ivr_choice` with menu, choice, timestamp, and session correlation; verify required headers are present and no SIP credential or unnecessary caller data is copied.
- [x] 7.7 Protect counters and lifecycle-sensitive state for concurrent sessions; verify a multichannel test loses and duplicates no completed invocations.
- [x] 7.8 Add module unit and harness tests for parsing, API output, application variables, events, invalid input, concurrency, and lifecycle; verify the documented test target passes without a production trunk.
- [x] 7.9 Add tutorial-only XML for sounds, DTMF collection, multi-level routing, and application invocation; verify it can be mounted into the lab, reloads successfully, and never adds files to `conf/vanilla`.
- [x] 7.10 Add an integration test that loads the module, calls the IVR path, selects branches, queries the API, receives the custom event, and observes the Prometheus counter; verify cleanup unloads only tutorial artifacts.

## 8. Docker, Certificates, and Monitoring

- [x] 8.1 Add the teaching-service container build with deterministic C++ and browser dependencies; verify a clean image build produces the service, assets, licenses, and test metadata.
- [ ] 8.2 Add a tutorial Compose overlay that extends the documented FreeSWITCH lab, publishes the site locally by default, mounts tutorial XML/module assets explicitly, and persists no production secrets; verify startup leaves existing Compose files unchanged.
- [x] 8.3 Add local certificate and trust guidance for HTTPS/WSS with separate localhost and remote-host cases; verify the browser preflight passes without disabling certificate validation.
- [x] 8.4 Add optional Prometheus configuration scraping only the teaching service; verify required metric families appear and Prometheus is not required for lesson reading or calling.
- [x] 8.5 Add lab sound-file prerequisites and checks for playback, phrase, and IVR prompts; verify a missing sound package produces an unavailable result with the documented install path.
- [ ] 8.6 Add end-to-end startup, shutdown, cleanup, and log-inspection documentation; verify repeated startup is idempotent and cleanup removes only tutorial containers, mounts, and generated data.
- [x] 8.7 Run a security-focused integration check for loopback defaults, public API secrets, arbitrary check rejection, event redaction, bounded buffers, and trace cleanup; verify all safeguards pass before curriculum sign-off.

## 9. Days 1-5: FreeSWITCH Foundations

- [x] 9.1 Author day 1 on the system model, learning site, lab contract, and health check; verify the content validator passes and a learner can distinguish signaling, media, control, and tutorial-service roles.
- [x] 9.2 Author day 2 on Docker processes, installed/source paths, ports, logs, and `fs_cli`; verify the guided lab reaches an `UP` status and identifies the relevant container/log evidence.
- [x] 9.3 Author day 3 on core versus loadable modules and build-time versus runtime loading; verify the learner can inspect compiled and loaded modules without confusing `modules.conf` with `modules.conf.xml`.
- [x] 9.4 Author day 4 on XML configuration domains, preprocessing, directory, dialplan, and variable timing; verify the lab resolves a tutorial user and route without editing the live compiled fsxml file.
- [x] 9.5 Author day 5 on users 1000/1001, registration, first SIP call, UUID, and logs; verify both registrations and bidirectional audio are checked with manual audio recorded separately.

## 10. Days 6-10: SIP and Media

- [x] 10.1 Author day 6 on SIP messages, transactions, dialogs, and call teardown; verify a captured call is annotated from REGISTER through BYE without publishing sensitive headers.
- [x] 10.2 Author day 7 on digest registration, directory lookup, and Sofia registration source flow; verify successful and failed authentication evidence maps to the documented source and configuration paths.
- [x] 10.3 Author day 8 on INVITE authentication, context selection, XML dialplan hunt, originate, and bridge; verify a dialed extension is traced through configuration and the referenced C entry points.
- [x] 10.4 Author day 9 on SDP, RTP, DTMF, codec negotiation, and transcoding; verify the learner identifies negotiated codecs and media ports from sanitized evidence.
- [x] 10.5 Author day 10 on NAT, advertised addresses, packet capture, and one-way audio; verify fault injection produces a diagnosed signaling-or-media cause and tracing is disabled after capture.

## 11. Days 11-15: WebRTC Audio

- [x] 11.1 Author day 11 on secure browser contexts, microphone permissions, audio devices, and preflight; verify grant, denial, and missing-device outcomes are demonstrated.
- [x] 11.2 Author day 12 on Sofia WS/WSS bindings, certificate trust, and browser SIP registration; verify the browser registers over WSS without bypassing certificate validation.
- [x] 11.3 Author day 13 on WebRTC SDP, ICE, DTLS-SRTP, and Opus; verify a call's sanitized negotiation evidence identifies each layer and the selected candidate/codec.
- [x] 11.4 Author day 14 on browser-to-SIP bridging and transcoding; verify the browser and SIP softphone exchange bidirectional audio and the codec path is observable.
- [x] 11.5 Author day 15 as a WSS, registration, ICE, codec, and no-audio troubleshooting challenge; verify each injected failure maps to a distinct diagnosis and recovery.

## 12. Days 16-20: IVR and ESL

- [x] 12.1 Author day 16 on answer, playback, recording, phrase macros, and sound packages; verify the learner hears a prompt and can diagnose a missing sound file.
- [x] 12.2 Author day 17 on DTMF collection, timeout, retry, terminator, and invalid input; verify valid, timeout, and invalid branches execute deterministically.
- [x] 12.3 Author day 18 on multi-level XML IVR, channel variables, and routing; verify every menu branch and safe exit path can be reached from the browser.
- [x] 12.4 Author day 19 on ESL authentication, command/reply, event subscription, and UUID correlation; verify the learner observes a call lifecycle without exposing the ESL password.
- [x] 12.5 Author day 20 on the minimal C++ ESL client and browser-to-IVR event trace; verify the client reconnects after interruption and follows one call from create through hangup.

## 13. Days 21-25: C/C++ Module Development

- [x] 13.1 Author day 21 on module definitions, load/shutdown, pools, interfaces, and the standalone build; verify `mod_tutorial` builds and its load evidence is visible.
- [x] 13.2 Author day 22 on the `tutorial_metrics` API, stream output, snapshots, and API testing; verify text, JSON, and unsupported-option behavior.
- [x] 13.3 Author day 23 on the `tutorial_ivr_metric` application, input parsing, channel variables, and failure safety; verify valid and invalid dialplan invocations.
- [x] 13.4 Author day 24 on custom event subclasses, bounded counters, locks, and concurrent calls; verify event fields and multichannel counter consistency.
- [x] 13.5 Author day 25 on load/unload failure paths, logging, tests, and source debugging; verify the full module suite and integration call pass and cleanup leaves FreeSWITCH running.

## 14. Days 26-30: Metrics and Capstone

- [x] 14.1 Author day 26 on `status`, HEARTBEAT, channel events, CDRs, correlation, and metric semantics; verify learners distinguish live gauges, counters, durations, and post-call records.
- [x] 14.2 Author day 27 on separate ESL connections, event normalization, immutable snapshots, and bounded retention; verify reconnect, duplicate-event, and overflow exercises.
- [x] 14.3 Author day 28 on Prometheus exposition, finite labels, health, and staleness; verify healthy and outage scrapes satisfy the observability spec.
- [x] 14.4 Author day 29 on website Event/Metrics panels and failure drills; verify FreeSWITCH down, ESL auth failure, stale heartbeat, and event overflow are correctly displayed.
- [x] 14.5 Author day 30 on the browser-to-IVR/SIP capstone, teaching module, ESL evidence, Metrics, final troubleshooting, and next-step source map; verify every capstone acceptance item records reproducible evidence.

## 15. Final Verification and Handoff

- [x] 15.1 Run the complete content validator and manually review Chinese terminology, source links, commands, expected output, safety labels, and locale fallback; verify all 30 lessons pass with no placeholders.
- [ ] 15.2 Run service and module unit tests, HTTP smoke tests, Docker integration, ESL reconnect, metric parsing, and security checks; verify all automated suites pass in the documented Ubuntu/Debian environment.
- [ ] 15.3 Execute the browser-to-SIP and browser-to-IVR manual acceptance on a clean lab, including two-way audio, DTMF, custom event, module API, Prometheus metric, failure drill, and cleanup; record actual results and any browser/environment limitations.
- [ ] 15.4 Review tutorial changes against repository rules, especially `conf/vanilla`, module loading distinctions, secrets, generated files, and unrelated worktree changes; verify the final diff is limited to the approved tutorial scope.
- [x] 15.5 Update `tutorial/README.md` with the validated start path, tested environment, test commands, known limitations, and English-localization follow-up; verify a new developer can start day 1 using only documented prerequisites.
