import { useState } from "react";
import { FlaskConical, Eye, Ear, Plus, ChevronRight, AlertTriangle, CheckCircle2 } from "lucide-react";
import { C } from "../constants/colors";

type Tab = "blood" | "eye" | "hearing";

const bloodTests = [
  {
    date: "Feb 15, 2026",
    lab: "City Medical Lab",
    results: [
      { name: "Hemoglobin", value: "12.8", unit: "g/dL", range: "12.0–16.0", status: "normal" },
      { name: "Blood Glucose (Fasting)", value: "5.8", unit: "mmol/L", range: "< 5.6", status: "high" },
      { name: "Total Cholesterol", value: "5.2", unit: "mmol/L", range: "< 5.0", status: "borderline" },
      { name: "HDL Cholesterol", value: "1.4", unit: "mmol/L", range: "> 1.2", status: "normal" },
      { name: "LDL Cholesterol", value: "3.1", unit: "mmol/L", range: "< 3.0", status: "borderline" },
      { name: "HbA1c", value: "5.9", unit: "%", range: "< 5.7", status: "high" },
      { name: "Creatinine", value: "78", unit: "µmol/L", range: "45–90", status: "normal" },
      { name: "TSH (Thyroid)", value: "2.1", unit: "mU/L", range: "0.4–4.0", status: "normal" },
    ],
  },
  {
    date: "Aug 12, 2025",
    lab: "City Medical Lab",
    results: [
      { name: "Hemoglobin", value: "13.1", unit: "g/dL", range: "12.0–16.0", status: "normal" },
      { name: "Blood Glucose (Fasting)", value: "5.6", unit: "mmol/L", range: "< 5.6", status: "borderline" },
      { name: "Total Cholesterol", value: "5.5", unit: "mmol/L", range: "< 5.0", status: "high" },
      { name: "HbA1c", value: "5.7", unit: "%", range: "< 5.7", status: "borderline" },
    ],
  },
];

const eyeTests = [
  {
    date: "Jan 10, 2026",
    doctor: "Dr. Aisha Patel",
    clinic: "City Eye Clinic",
    prescription: {
      rightEye: { sphere: "-2.25", cylinder: "-0.50", axis: "180", add: "+1.50" },
      leftEye: { sphere: "-2.00", cylinder: "-0.25", axis: "175", add: "+1.50" },
    },
    notes: "Mild astigmatism stable. Reading glasses recommended. No signs of macular degeneration. Next exam in 12 months.",
    nextDue: "Jan 2027",
  },
  {
    date: "Jan 8, 2025",
    doctor: "Dr. Aisha Patel",
    clinic: "City Eye Clinic",
    prescription: {
      rightEye: { sphere: "-2.25", cylinder: "-0.50", axis: "178", add: "+1.25" },
      leftEye: { sphere: "-2.00", cylinder: "-0.25", axis: "173", add: "+1.25" },
    },
    notes: "Prescription unchanged. Mild dry eye syndrome. Recommend lubricating drops.",
    nextDue: "Jan 2026",
  },
];

const hearingTests = [
  {
    date: "Nov 14, 2025",
    audiologist: "Dr. Mark Thompson",
    clinic: "St. Mary's ENT Clinic",
    results: {
      rightEar: "Mild high-frequency loss (4–8 kHz range, 25–35 dB)",
      leftEar: "Within normal limits",
    },
    recommendation: "Monitoring recommended annually. No hearing aid required at this stage. Avoid prolonged exposure to loud environments.",
    nextDue: "Nov 2026",
  },
];

const statusColors: Record<string, { text: string; bg: string; icon: React.ReactNode }> = {
  normal: { text: "#5dab6f", bg: "#eef8f1", icon: <CheckCircle2 size={13} color="#5dab6f" /> },
  high: { text: "#c75050", bg: "#fceaea", icon: <AlertTriangle size={13} color="#c75050" /> },
  borderline: { text: "#c47c2f", bg: "#fff8e8", icon: <AlertTriangle size={13} color="#c47c2f" /> },
};

const statusLabel: Record<string, string> = {
  normal: "Normal",
  high: "Above range",
  borderline: "Borderline",
};

export function MedicalTests() {
  const [activeTab, setActiveTab] = useState<Tab>("blood");
  const [expandedTest, setExpandedTest] = useState<number>(0);

  return (
    <div style={{ background: C.bg, paddingBottom: "24px", fontFamily: '"Open Sans", sans-serif' }}>
      {/* Header */}
      <div style={{ background: `linear-gradient(135deg, #8b6fa0 0%, #7a5c90 100%)`, padding: "20px 20px 32px", position: "relative", overflow: "hidden" }}>
        <div style={{ position: "absolute", top: "-20px", right: "-20px", width: "100px", height: "100px", borderRadius: "50px", background: "rgba(255,255,255,0.1)" }} />
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <div>
            <h1 style={{ color: "white", fontSize: "22px", fontWeight: "700", margin: "0 0 4px" }}>Medical Tests</h1>
            <p style={{ color: "rgba(255,255,255,0.8)", fontSize: "13px", margin: 0 }}>Blood · Eye · Hearing results</p>
          </div>
          <button style={{ background: "rgba(255,255,255,0.25)", border: "none", borderRadius: "14px", padding: "10px 16px", cursor: "pointer", display: "flex", alignItems: "center", gap: "6px" }}>
            <Plus size={18} color="white" />
            <span style={{ color: "white", fontSize: "14px", fontWeight: "600", fontFamily: '"Open Sans", sans-serif' }}>Add</span>
          </button>
        </div>
      </div>

      {/* Tab Bar */}
      <div style={{ margin: "-16px 16px 0", position: "relative", zIndex: 10, marginBottom: "16px" }}>
        <div style={{ background: C.card, borderRadius: "16px", padding: "6px", display: "flex", boxShadow: "0 4px 16px rgba(84,70,58,0.1)" }}>
          {([
            { id: "blood", label: "Blood Tests", icon: FlaskConical },
            { id: "eye", label: "Eyesight", icon: Eye },
            { id: "hearing", label: "Hearing", icon: Ear },
          ] as { id: Tab; label: string; icon: any }[]).map(({ id, label, icon: Icon }) => (
            <button
              key={id}
              onClick={() => setActiveTab(id)}
              style={{
                flex: 1,
                padding: "10px 4px",
                borderRadius: "12px",
                border: "none",
                cursor: "pointer",
                background: activeTab === id ? "#8b6fa0" : "transparent",
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                gap: "4px",
                transition: "all 0.2s",
                fontFamily: '"Open Sans", sans-serif',
              }}
            >
              <Icon size={18} color={activeTab === id ? "white" : C.textSecondary} />
              <span style={{ fontSize: "11px", fontWeight: "600", color: activeTab === id ? "white" : C.textSecondary }}>{label}</span>
            </button>
          ))}
        </div>
      </div>

      {/* Blood Tests */}
      {activeTab === "blood" && (
        <div style={{ padding: "0 16px" }}>
          {bloodTests.map((test, ti) => (
            <div key={ti} style={{ background: C.card, borderRadius: "20px", marginBottom: "12px", overflow: "hidden", boxShadow: "0 2px 12px rgba(84,70,58,0.07)" }}>
              <button
                onClick={() => setExpandedTest(expandedTest === ti ? -1 : ti)}
                style={{ width: "100%", padding: "14px 16px", background: "none", border: "none", cursor: "pointer", display: "flex", justifyContent: "space-between", alignItems: "center", fontFamily: '"Open Sans", sans-serif' }}
              >
                <div style={{ textAlign: "left" }}>
                  <p style={{ fontSize: "15px", fontWeight: "700", color: C.textPrimary, margin: "0 0 2px" }}>{test.date}</p>
                  <p style={{ fontSize: "13px", color: C.textSecondary, margin: 0 }}>{test.lab} · {test.results.length} markers</p>
                </div>
                <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                  {test.results.filter((r) => r.status !== "normal").length > 0 && (
                    <div style={{ background: "#fceaea", borderRadius: "8px", padding: "3px 8px", display: "flex", alignItems: "center", gap: "4px" }}>
                      <AlertTriangle size={12} color="#c75050" />
                      <span style={{ fontSize: "11px", color: "#c75050", fontWeight: "600" }}>{test.results.filter((r) => r.status !== "normal").length}</span>
                    </div>
                  )}
                  <ChevronRight size={16} color={C.textSecondary} style={{ transform: expandedTest === ti ? "rotate(90deg)" : "none", transition: "transform 0.2s" }} />
                </div>
              </button>

              {expandedTest === ti && (
                <div style={{ borderTop: `1px solid ${C.border}` }}>
                  {test.results.map((result, ri) => {
                    const s = statusColors[result.status];
                    return (
                      <div
                        key={ri}
                        style={{
                          display: "flex",
                          alignItems: "center",
                          justifyContent: "space-between",
                          padding: "12px 16px",
                          borderBottom: ri < test.results.length - 1 ? `1px solid ${C.border}` : "none",
                          background: ri % 2 === 0 ? "transparent" : `${C.bg}88`,
                        }}
                      >
                        <div style={{ flex: 1 }}>
                          <p style={{ fontSize: "13px", color: C.textPrimary, margin: "0 0 2px", fontWeight: "500" }}>{result.name}</p>
                          <p style={{ fontSize: "11px", color: C.textSecondary, margin: 0 }}>Range: {result.range}</p>
                        </div>
                        <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                          <span style={{ fontSize: "15px", fontWeight: "700", color: C.textPrimary }}>{result.value} <span style={{ fontSize: "12px", fontWeight: "400", color: C.textSecondary }}>{result.unit}</span></span>
                          <div style={{ background: s.bg, borderRadius: "8px", padding: "3px 8px", display: "flex", alignItems: "center", gap: "4px" }}>
                            {s.icon}
                            <span style={{ fontSize: "11px", color: s.text, fontWeight: "600" }}>{statusLabel[result.status]}</span>
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              )}
            </div>
          ))}
        </div>
      )}

      {/* Eye Tests */}
      {activeTab === "eye" && (
        <div style={{ padding: "0 16px" }}>
          {eyeTests.map((test, ti) => (
            <div key={ti} style={{ background: C.card, borderRadius: "20px", marginBottom: "12px", overflow: "hidden", boxShadow: "0 2px 12px rgba(84,70,58,0.07)" }}>
              <div style={{ padding: "16px" }}>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: "12px" }}>
                  <div>
                    <p style={{ fontSize: "15px", fontWeight: "700", color: C.textPrimary, margin: "0 0 2px" }}>{test.date}</p>
                    <p style={{ fontSize: "13px", color: C.textSecondary, margin: 0 }}>{test.doctor} · {test.clinic}</p>
                  </div>
                  <div style={{ background: C.sage50, borderRadius: "10px", padding: "4px 10px" }}>
                    <span style={{ fontSize: "12px", color: C.sageDark, fontWeight: "600" }}>Next: {test.nextDue}</span>
                  </div>
                </div>

                {/* Prescription grid */}
                <div style={{ background: C.bg, borderRadius: "14px", padding: "12px", marginBottom: "12px" }}>
                  <p style={{ fontSize: "12px", fontWeight: "700", color: C.textSecondary, textTransform: "uppercase", letterSpacing: "0.5px", margin: "0 0 10px" }}>Prescription</p>
                  <div style={{ display: "grid", gridTemplateColumns: "auto 1fr 1fr 1fr 1fr", gap: "6px", alignItems: "center" }}>
                    <span style={{ fontSize: "11px", color: C.textSecondary }}></span>
                    {["Sphere", "Cylinder", "Axis", "Add"].map((h) => (
                      <span key={h} style={{ fontSize: "11px", fontWeight: "600", color: C.textSecondary, textAlign: "center" }}>{h}</span>
                    ))}
                    {[["R", test.prescription.rightEye], ["L", test.prescription.leftEye]].map(([eye, rx]: any) => (
                      <div key={eye} style={{ display: "contents" }}>
                        <span style={{ fontSize: "13px", fontWeight: "700", color: C.primary, width: "20px" }}>{eye}</span>
                        {[rx.sphere, rx.cylinder, rx.axis, rx.add].map((v: string, vi: number) => (
                          <span key={`${eye}-${vi}`} style={{ fontSize: "13px", color: C.textPrimary, fontWeight: "500", textAlign: "center" }}>{v}</span>
                        ))}
                      </div>
                    ))}
                  </div>
                </div>

                <div style={{ background: "#f0f8ff", borderRadius: "12px", padding: "10px 12px" }}>
                  <p style={{ fontSize: "13px", color: "#4a7fa5", margin: 0, lineHeight: "1.5" }}>{test.notes}</p>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Hearing Tests */}
      {activeTab === "hearing" && (
        <div style={{ padding: "0 16px" }}>
          {hearingTests.map((test, ti) => (
            <div key={ti} style={{ background: C.card, borderRadius: "20px", marginBottom: "12px", overflow: "hidden", boxShadow: "0 2px 12px rgba(84,70,58,0.07)" }}>
              <div style={{ padding: "16px" }}>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: "12px" }}>
                  <div>
                    <p style={{ fontSize: "15px", fontWeight: "700", color: C.textPrimary, margin: "0 0 2px" }}>{test.date}</p>
                    <p style={{ fontSize: "13px", color: C.textSecondary, margin: 0 }}>{test.audiologist}</p>
                    <p style={{ fontSize: "12px", color: C.textSecondary, margin: "1px 0 0" }}>{test.clinic}</p>
                  </div>
                  <div style={{ background: C.sage50, borderRadius: "10px", padding: "4px 10px" }}>
                    <span style={{ fontSize: "12px", color: C.sageDark, fontWeight: "600" }}>Next: {test.nextDue}</span>
                  </div>
                </div>

                <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "10px", marginBottom: "12px" }}>
                  <div style={{ background: "#fceaea", borderRadius: "14px", padding: "12px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: "6px", marginBottom: "6px" }}>
                      <AlertTriangle size={14} color="#c75050" />
                      <span style={{ fontSize: "12px", fontWeight: "600", color: "#c75050" }}>Right Ear</span>
                    </div>
                    <p style={{ fontSize: "12px", color: C.textPrimary, margin: 0, lineHeight: "1.4" }}>{test.results.rightEar}</p>
                  </div>
                  <div style={{ background: "#eef8f1", borderRadius: "14px", padding: "12px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: "6px", marginBottom: "6px" }}>
                      <CheckCircle2 size={14} color="#5dab6f" />
                      <span style={{ fontSize: "12px", fontWeight: "600", color: "#5dab6f" }}>Left Ear</span>
                    </div>
                    <p style={{ fontSize: "12px", color: C.textPrimary, margin: 0, lineHeight: "1.4" }}>{test.results.leftEar}</p>
                  </div>
                </div>

                <div style={{ background: C.sage50, borderRadius: "12px", padding: "12px", border: `1px solid ${C.sage}44` }}>
                  <p style={{ fontSize: "12px", fontWeight: "700", color: C.sageDark, margin: "0 0 4px", textTransform: "uppercase", letterSpacing: "0.5px" }}>Recommendation</p>
                  <p style={{ fontSize: "13px", color: C.textPrimary, margin: 0, lineHeight: "1.5" }}>{test.recommendation}</p>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}