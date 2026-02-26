# PRD: EyeRx — Mobile Eyesight Testing & Lens Referral App

**Version:** 0.1 (Draft)
**Date:** 2026-02-26
**Status:** Draft for Review

---

## 1. Overview

### 1.1 Product Vision

EyeRx is an iOS application that empowers users to self-administer a validated, guided vision test using only their iPhone, receive an estimated refractive prescription, and seamlessly order custom-ground lenses — fitted into their existing frames or a new pair — without requiring an in-person optometrist visit for routine prescription renewals.

### 1.2 Problem Statement

- Routine eye exams cost $100–$250 out-of-pocket and require scheduling weeks in advance.
- ~50% of prescription wearers are overdue for an updated prescription due to access, cost, or time barriers.
- Lens ordering from an optician is fragmented: users get a paper Rx and must re-enter it at a separate vendor.
- No end-to-end mobile solution connects measurement → prescription → lens grinding → frame fulfillment.

### 1.3 Target Users

| Segment | Description |
|---|---|
| **Primary** | Adults aged 18–65 with known refractive error (myopia, hyperopia, astigmatism) seeking a renewal of a stable prescription |
| **Secondary** | Users who have never been tested and suspect they need correction |
| **Excluded (v1)** | Children under 18, users with pathological conditions (cataracts, glaucoma, macular degeneration), post-surgical eyes (LASIK, cataract surgery) |

---

## 2. Regulatory & Legal Context

> **This section must be reviewed by legal and regulatory counsel before any public release.**

### 2.1 FDA Classification

- Software that generates a prescription for corrective lenses may be classified as a **Class II Medical Device** (FDA 21 CFR Part 886 — Ophthalmic Devices).
- The app must evaluate whether it qualifies for **De Novo classification**, **510(k) clearance**, or falls under the **Software as a Medical Device (SaMD)** framework (IMDRF guidance).
- Alternatively, the product may be positioned as a **screening tool** that generates a *suggested* prescription for review and countersignature by a licensed optometrist or ophthalmologist via a telehealth layer (reducing regulatory burden significantly).

### 2.2 State Telemedicine & Prescribing Laws

- Prescribing contact/optical lens Rxs via telemedicine without an in-person exam is **illegal in several U.S. states**.
- A licensed eye care professional (ECP) must be in the review loop in states that require it (currently ~12 states require at minimum asynchronous review).
- The product must include a state-aware compliance gate at onboarding.

### 2.3 Liability & Disclaimers

- The app must clearly communicate it is **not a replacement for a comprehensive eye health exam**.
- Users with sudden vision changes, eye pain, flashes, or floaters must be directed to emergency care.
- HIPAA compliance required for storage and transmission of health data.

---

## 3. Core Features

### 3.1 Feature Set Overview

| # | Feature | Priority | Release |
|---|---|---|---|
| F1 | Vision Screening Test (Visual Acuity) | P0 | v1 |
| F2 | Refraction Estimation Engine | P0 | v1 |
| F3 | Astigmatism & Axis Detection | P0 | v1 |
| F4 | Prescription Output & Storage | P0 | v1 |
| F5 | Licensed ECP Telehealth Review | P0 | v1 |
| F6 | Lens Grinder Referral & Order Flow | P0 | v1 |
| F7 | Frame Measurement (PD, frame sizing) | P1 | v1 |
| F8 | New Frame Marketplace | P1 | v1 |
| F9 | Existing Frame Lens Replacement Flow | P0 | v1 |
| F10 | Order Tracking & Fulfillment | P1 | v1 |
| F11 | Prescription History & Trends | P2 | v2 |
| F12 | Pediatric Mode | P3 | v3 |

---

## 4. Detailed Feature Specifications

### 4.1 F1 — Vision Screening Test (Visual Acuity)

**Goal:** Measure best-corrected and uncorrected distance visual acuity using a Snellen-equivalent chart rendered on the device screen.

**User Flow:**
1. User is prompted to stand exactly **3 meters** from the phone (propped or mounted). Distance is validated using the **TrueDepth camera / LiDAR scanner** (iPhone 12 Pro+) or ARKit world-tracking for devices without LiDAR.
2. App adjusts on-screen optotype size dynamically based on confirmed distance.
3. Test is administered monocularly (right eye, then left eye). User covers the non-tested eye and taps or speaks responses.
4. Test proceeds through decreasing optotype sizes (Tumbling E / Landolt C to avoid literacy bias) until threshold is reached.
5. Results logged as Snellen fraction equivalents (e.g., 20/40, 20/20).

**Hardware Instrumentation Used:**
- LiDAR Scanner (A14 Bionic and newer, or LiDAR-equipped iPads/iPhones) — for precise distance measurement
- ARKit — world-tracking, plane detection, distance anchoring
- Front-facing TrueDepth camera — head position tracking, gaze estimation, ensuring user is positioned correctly
- Display (calibrated nits, pixel density) — for accurate optotype rendering at calculated angular subtense
- Microphone — optional voice response input

**Accuracy Considerations:**
- Screen brightness must be calibrated to ≥ 80 cd/m² (ETDRS standard).
- Ambient light sensor used to flag poor testing environment.
- Optotype size must be rendered at exact angular subtense: 5 arcminutes per optotype height at confirmed test distance.

---

### 4.2 F2 — Refraction Estimation Engine

**Goal:** Estimate the spherical equivalent (sphere, cylinder, axis) of the user's refractive error.

**Method — Wavefront Sensing via Camera (Research-Informed):**
The core innovation uses the **rear camera system** combined with a proprietary algorithm to estimate wavefront aberrations. Two primary approaches are evaluated:

#### Option A: Hartmann-Shack Approximation via Camera (Preferred)
- User holds a printed or screen-displayed dot-grid calibration target at a known distance.
- The rear camera captures micro-distortions in the reflected/transmitted pattern.
- Aberrations in the captured image are used to back-calculate the wavefront error and derive a spherical + cylindrical correction estimate.
- Accuracy target: ±0.50 D sphere, ±0.50 D cylinder (consistent with FDA-validated competitors such as Warby Parker's Prescription Check).

#### Option B: Subjective Bracketing (Fallback / Supplement)
- Psychophysical method: user views gratings, Vernier alignment targets, and astigmatic dials on screen.
- Answers series of forced-choice questions ("Which is clearer: A or B?") converging on best-corrected acuity.
- Equivalent to a simplified in-office subjective refraction.
- Less precise than Option A but viable on all iPhone models.

**Final Prescription Output:**
- Sphere (SPH): –20.00 D to +20.00 D in 0.25 D steps
- Cylinder (CYL): 0.00 D to –6.00 D in 0.25 D steps
- Axis: 1°–180°
- Add power (for presbyopia): +0.75 D to +3.50 D in 0.25 D steps
- Pupillary Distance (PD): monocular and binocular (see F7)

---

### 4.3 F3 — Astigmatism & Axis Detection

**Goal:** Detect the presence, magnitude, and orientation of corneal/refractive astigmatism.

**Methods:**
- **Clock dial / Jackson cross-cylinder analog** rendered on screen during subjective test.
- **Camera-based corneal reflex analysis**: front camera captures corneal reflection patterns under controlled (known) illumination from the screen to estimate keratometric astigmatism axis (comparable to hand-held autorefractors).
- Axis confirmation via user-guided orientation of a rotating line grating target.

---

### 4.4 F4 — Prescription Output & Storage

**Prescription Card:**
- Displayed in standard optical format (OD/OS, SPH/CYL/AXIS/ADD/PD).
- Exportable as PDF, shareable via AirDrop, Messages, or direct API push to partner labs.
- Stored encrypted in the user's iCloud Keychain / HealthKit (with consent).

**Validity & Expiry:**
- Prescription is tagged with issue date.
- Users reminded at 12 months (contacts) / 24 months (glasses) to retest.
- Prescription validity laws by state are enforced in the app (e.g., some states limit to 1 year).

---

### 4.5 F5 — Licensed ECP Telehealth Review

**Goal:** Route completed test results to a licensed optometrist for async review and legal Rx countersignature within 24 hours.

**Flow:**
1. Test results and camera data are uploaded (encrypted, HIPAA-compliant) to a telehealth platform partner (e.g., integrated with 1-800 Contacts' telehealth network, Opternative-model service, or in-house network of licensed ECPs).
2. ECP reviews: raw vision data, estimated refraction, flagged anomalies.
3. ECP either countersigns (generating a legal prescription), requests a clarification step, or declines with a recommendation for in-person visit.
4. User notified via push notification. Prescription unlocked in app if countersigned.
5. Fee: $20–$35 professional review fee collected in-app.

**ECP Escalation Flags (automatic — ECP must review before Rx release):**
- Visual acuity < 20/200 in either eye
- Rapid change > 1.50 D from prior prescription on file
- Anisometropia > 2.00 D difference between eyes
- Irregular astigmatism pattern detected
- Asymmetric test behavior suggesting pathology

---

### 4.6 F6 — Lens Grinder Referral & Order Flow

**Goal:** Convert the countersigned prescription into a lens fabrication order placed with a certified optical lab.

**Lab Partner Integration:**
- App connects to a network of **surfacing / wholesale optical labs** via API (e.g., Vision Service Plan labs, FEA Industries, Optical Dynamics, independent regional labs).
- Prescription is transmitted in **ANSI Z80.1 standard format** (standard for optical lab data exchange).
- Lab partner options ranked by: turnaround time, geographic proximity, supported lens types, price tier.

**Lens Configuration Options (user selects):**
| Option | Details |
|---|---|
| Lens material | CR-39 (standard), Polycarbonate, Trivex, Hi-Index 1.67, Hi-Index 1.74 |
| Lens type | Single vision, Bifocal (flat-top 28), Progressive (standard / premium) |
| Coatings | Anti-reflective, Blue light filter, Photochromic (Transitions), UV400, Scratch-resistant |
| Tint | Clear, Grey, Brown, Fashion tints, Mirror |
| Thickness | Standard, Thin, Ultra-thin (based on Rx power) |

**Pricing:**
- Lab-direct pricing displayed transparently.
- Estimated pricing range: $30–$120 depending on material and coatings (single vision).
- Progressive lenses: $80–$250 depending on tier.
- Shipping + handling: $15–$30.

---

### 4.7 F7 — Pupillary Distance (PD) Measurement

**Goal:** Measure monocular and binocular PD accurately using the iPhone front camera and a reference object.

**Method:**
- User holds a standard reference card (credit card / driver's license) against their forehead under the camera, or uses a printed ruler PDF.
- TrueDepth camera + face mesh (ARKit Face Tracking) triangulates the corneal reflex positions.
- PD measured as distance between pupil centers for distance (primary gaze) and near (convergence).
- Accuracy target: ±0.5 mm (clinically acceptable for most prescriptions; ≤ ±0.25 mm required for progressives, flagged accordingly).

**Alternative:** Frame-based measurement — if user photographs themselves wearing their existing frames, app detects frame bridge center and pupil position relative to it.

---

### 4.8 F8 — New Frame Marketplace

**Goal:** Allow users who want new frames to browse and purchase within the app, with lenses installed before shipping.

**Frame Catalog:**
- Curated catalog of 200–500 frames at launch (house brand + 2–3 licensed brands).
- Frames filterable by: face shape recommendation (AR try-on), material, color, size, price.
- **AR Virtual Try-On**: uses TrueDepth + ARKit face mesh to render frames on user's face in real time.
- Frame measurements stored (A-B-DBL-temple length) to match PD and lens sizing needs.

**Fulfillment:**
- Frames sourced from manufacturer, sent to optical lab with prescription → lenses cut and edged into frames → shipped direct to user.
- Or: Lab-in-frame partner (frame + lens grinding + assembly in one location).

---

### 4.9 F9 — Existing Frame Lens Replacement Flow

**Goal:** Allow users to send in their existing frames to have new lenses ground and installed.

**Flow:**
1. User selects "Use My Existing Frames."
2. App generates a prepaid **mailer label** (USPS, FedEx) to ship frames to optical lab.
3. User ships frames. Lab photographs frames on receipt, confirms frame condition and measurements, sends confirmation to user.
4. Lab grinds lenses to prescription, edges them to fit existing frame, assembles, and ships back.
5. Turnaround target: 5–10 business days from receipt of frames.
6. If frames are damaged or unusable, user is notified with option to select a new frame from marketplace.

**Frame Measurement from Photo (Alternative):**
- User photographs their existing frames on a flat surface with a reference card.
- App's CV model estimates A, B, DBL, and temple measurements for lab intake — eliminates need to mail frames in some cases.

---

### 4.10 F10 — Order Tracking & Fulfillment

- Real-time order status: Rx verified → Lab received → In fabrication → QC → Shipped → Delivered.
- Push notifications at each stage.
- In-app chat/support for order issues.
- Return/remake policy: 30-day remakes if prescription is uncomfortable (standard in the optical industry).

---

## 5. User Experience & Design Principles

### 5.1 Onboarding

1. Welcome + vision health context
2. Age verification (18+) and medical history intake (prior Rx, known conditions)
3. State compliance check → telehealth consent
4. Tutorial: environment setup (lighting, distance, phone mounting)
5. Practice round with easy targets before real test begins

### 5.2 Test Environment Requirements (Communicated to User)

- **Lighting:** Ambient light ≥ 300 lux (measured via ambient light sensor); direct glare on screen must be avoided.
- **Distance:** 3.0 m ± 10 cm (validated by LiDAR/ARKit before test starts).
- **Phone orientation:** Landscape, mounted or propped at eye level.
- **Quiet environment:** Microphone voice input optional.
- **Remove contact lenses** before testing uncorrected vision (instructions given).

### 5.3 Accessibility

- Tumbling E and Landolt C optotypes (no literacy requirement).
- Voice-guided instructions (VoiceOver compatible, but note: VoiceOver on = cannot test vision).
- High contrast UI.
- Large tap targets for users with low vision interacting with the setup screens.

### 5.4 Key UX Principles

- **Trust-first:** Heavy emphasis on clinical credibility, ECP involvement, FDA/regulatory transparency.
- **Zero jargon until Rx screen:** All test screens use plain language; prescription screen provides a plain-language explainer.
- **Friction in the right places:** Confirmation dialogs before submitting order; prescription locked until ECP review.
- **Progressive disclosure:** Don't overwhelm — surface lens options one decision at a time.

---

## 6. Technical Architecture (High Level)

### 6.1 iOS App Stack

| Layer | Technology |
|---|---|
| Language | Swift 6 |
| UI Framework | SwiftUI |
| Computer Vision | Vision framework, ARKit, Core ML |
| LiDAR / Depth | ARKit + RealityKit |
| Face Tracking | ARKit (TrueDepth camera) |
| Camera Pipeline | AVFoundation |
| Health Data | HealthKit (with user consent) |
| Secure Storage | Keychain + iCloud Keychain |
| Networking | URLSession + async/await; TLS 1.3 |

### 6.2 Backend Services

| Service | Responsibility |
|---|---|
| Prescription Service | Store, validate, version Rx records |
| ECP Telehealth Gateway | Route test data to reviewing clinician; receive countersignature |
| Lab Order Service | Translate Rx to ANSI Z80.1, dispatch to lab partner API |
| Frame Catalog Service | Product catalog, inventory, pricing |
| Fulfillment Service | Order tracking, shipping label generation, return management |
| Auth / Identity | Sign in with Apple + HIPAA-compliant identity |
| Analytics | Anonymized aggregated usage (opt-in) |

### 6.3 Minimum Device Requirements

| Requirement | Minimum |
|---|---|
| iPhone model | iPhone 12 (for LiDAR: iPhone 12 Pro+) |
| iOS version | iOS 17.0 |
| Camera | 12 MP rear camera required |
| TrueDepth | Required for PD measurement and face tracking |
| LiDAR | Required for precision distance measurement; fallback ARKit for non-LiDAR |

---

## 7. Metrics & Success Criteria

### 7.1 Clinical Accuracy KPIs

| Metric | Target |
|---|---|
| Sphere accuracy (vs. manifest refraction) | Mean error ≤ 0.25 D, 90th pctile ≤ 0.50 D |
| Cylinder accuracy | Mean error ≤ 0.25 D |
| Axis accuracy | Mean error ≤ 10° for CYL ≥ 0.50 D |
| PD accuracy | Mean error ≤ 0.5 mm |
| ECP approval rate (no modification) | ≥ 70% of submissions approved as-is |

### 7.2 Product KPIs

| Metric | Target (12 months post-launch) |
|---|---|
| Test completion rate | ≥ 65% of users who start a test complete it |
| Prescription-to-order conversion | ≥ 30% |
| Net Promoter Score | ≥ 50 |
| ECP turnaround time (median) | ≤ 8 hours |
| Order fulfillment time (frame mail-in) | ≤ 10 business days |
| Remake request rate | ≤ 8% |

---

## 8. Risk Register

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| FDA classifies app as Class III device | Medium | Critical | Early pre-sub meeting with FDA; position as screening + telehealth, not autonomous Rx generator |
| Refraction algorithm accuracy insufficient | Medium | High | Clinical validation study (n ≥ 200) before launch; limit to mild-moderate Rx range in v1 |
| State-by-state telemedicine restrictions | High | High | State-aware compliance layer; legal review of each state before enabling |
| Lab partner data breach (HIPAA) | Low | Critical | BAA with all lab partners; end-to-end encryption; audit logging |
| User tests in poor lighting conditions | High | Medium | Mandatory environment check with hard gate (refuse to start test if criteria not met) |
| Frames lost or damaged in mail-in flow | Medium | Medium | Prepaid insurance on all mailers; photographic condition documentation on receipt |
| User with undetected pathology gets Rx | Low | Critical | Mandatory ECP review; symptom screener at intake; clear escalation language |

---

## 9. Go-To-Market Considerations

### 9.1 Monetization Model

| Revenue Stream | Model |
|---|---|
| ECP Review Fee | $25 flat fee per prescription test session |
| Lens Orders | Margin on lab-direct lens pricing (est. 30–45%) |
| Frame Sales | Margin on frames sold via in-app marketplace |
| Subscription (v2) | Annual plan for unlimited retests + priority ECP review + storage |

### 9.2 Launch Strategy

- **Phase 1 (Private Beta):** Clinical validation study with optometry partners; 500 invited users in permissive telehealth states.
- **Phase 2 (Limited Launch):** 10 U.S. states with favorable telemedicine laws; existing-prescription-only users (strongest safety profile).
- **Phase 3 (Full Launch):** All 50 states with state-specific compliance configuration; new-prescription users added.

### 9.3 Regulatory Pathway Timeline (Estimated)

| Milestone | Estimated Timeline |
|---|---|
| Pre-submission meeting with FDA | Month 3 |
| Clinical validation study design | Month 4–6 |
| Clinical data collection (n=200+) | Month 6–10 |
| 510(k) or De Novo submission | Month 12 |
| FDA clearance (estimated) | Month 18–24 |
| Full commercial launch | Month 24–26 |

---

## 10. Open Questions for Stakeholder Alignment

1. **Regulatory strategy**: Pursue FDA clearance proactively (slower, safer) or launch under screening + telehealth framing (faster, riskier)?
2. **ECP network**: Build proprietary telehealth network of ECPs or partner with existing telehealth platform (1-800 Contacts, Eyes Online, etc.)?
3. **Lab partner strategy**: Single exclusive lab partner for quality control, or multi-lab marketplace for coverage and price competition?
4. **Frame sourcing**: Private-label frames only, or license established brands (Warby Parker model)?
5. **Mail-in frame flow**: Is the operational complexity of a frame mail-in program worth the v1 scope, or should v1 be new-frames-only?
6. **Algorithm development**: License existing refraction algorithm (e.g., from academic spinout), build in-house, or acquire?
7. **International expansion**: Prioritize Canada/UK/AUS in v2, given different regulatory frameworks and lab availability?
8. **Pediatric roadmap**: What clinical validation and regulatory pathway is required to support users under 18 in a future version?

---

## 11. Appendix

### A. Competitive Landscape

| Competitor | Approach | Prescription | Lens Order | Status |
|---|---|---|---|---|
| Warby Parker Prescription Check | Subjective acuity test + ECP review | Yes (ECP countersign) | Through Warby Parker store | Live (limited states) |
| Opternative | Acuity + subjective refraction + ECP | Yes | No (Rx only) | Acquired/discontinued |
| GlassesUSA / Zenni | No in-app testing | No | Yes (user enters Rx) | Live |
| Smart Vision Labs | Wavefront autorefraction hardware dongle | Yes | No | B2B / clinical settings |
| **EyeRx (this app)** | Acuity + wavefront estimation + ECP + lens order + frame | Yes | Yes (full funnel) | Proposed |

### B. Relevant Standards & Frameworks

- **ANSI Z80.1-2020** — Requirements for Prescription Ophthalmic Lenses
- **ANSI Z80.28-2021** — Methods for Reporting Optical Parameters of Spectacle Lenses
- **ISO 10342:2010** — Ophthalmic Instruments — Refractometers
- **IMDRF SaMD Framework** — Software as a Medical Device classification guidance
- **FDA 21 CFR Part 820** — Quality System Regulation (medical device manufacturing)
- **HIPAA 45 CFR Part 164** — Security and Privacy Rules
- **FTC Eyeglass Rule (16 CFR Part 456)** — Patients' rights to their prescription

---

*Document Owner: Product Management*
*Next Review: Upon stakeholder alignment on Open Questions (Section 10)*
*Classification: Internal Draft — Not for External Distribution*
