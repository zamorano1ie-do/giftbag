import { useState } from "react";
import { Pill, Plus, RefreshCw, Clock, AlertTriangle, CheckCircle2, ChevronRight, Calendar } from "lucide-react";
import { C } from "../constants/colors";

const activeMeds = [
  {
    name: "Lisinopril",
    dose: "10 mg",
    frequency: "Once daily",
    timing: "Morning with food",
    reason: "Blood pressure",
    doctor: "Dr. Sarah Chen",
    startDate: "Mar 2025",
    refillDate: "Mar 15, 2026",
    daysLeft: 10,
    taken: true,
    color: C.primary,
    icon: "💊",
    instructions: "Take in the morning with or without food. Avoid potassium supplements unless directed.",
    sideEffects: "Dry cough, dizziness. Contact doctor if you develop swelling of face/throat.",
  },
  {
    name: "Atorvastatin",
    dose: "20 mg",
    frequency: "Once daily",
    timing: "Evening",
    reason: "High cholesterol",
    doctor: "Dr. Sarah Chen",
    startDate: "Jun 2024",
    refillDate: "Apr 1, 2026",
    daysLeft: 27,
    taken: false,
    color: "#5a88c4",
    icon: "💙",
    instructions: "Take in the evening. Avoid large amounts of grapefruit juice.",
    sideEffects: "Muscle aches are rare but important — contact doctor if they occur.",
  },
  {
    name: "Metformin",
    dose: "500 mg",
    frequency: "Twice daily",
    timing: "Morning & evening with meals",
    reason: "Pre-diabetes (blood sugar control)",
    doctor: "Dr. Sarah Chen",
    startDate: "Feb 2026",
    refillDate: "Mar 30, 2026",
    daysLeft: 25,
    taken: true,
    color: "#5dab6f",
    icon: "🟢",
    instructions: "Always take with meals to reduce stomach upset. Do not skip meals.",
    sideEffects: "Nausea and stomach upset common when first starting. Usually improves after 2–3 weeks.",
  },
  {
    name: "Vitamin D3",
    dose: "1000 IU",
    frequency: "Once daily",
    timing: "Morning with food",
    reason: "Supplement — Vitamin D deficiency",
    doctor: "Dr. Sarah Chen",
    startDate: "Jan 2025",
    refillDate: "Ongoing",
    daysLeft: 999,
    taken: true,
    color: "#c47c2f",
    icon: "☀️",
    instructions: "Take with a fatty meal for best absorption.",
    sideEffects: "Generally well tolerated at this dose.",
  },
];

const pastMeds = [
  { name: "Amoxicillin 500mg", reason: "Respiratory infection", period: "Dec 8–13, 2025", doctor: "Dr. Sarah Chen", status: "Completed" },
  { name: "Ibuprofen 400mg", reason: "Knee pain (post-physio)", period: "Oct 2025", doctor: "Dr. Sarah Chen", status: "Completed" },
];

export function Prescriptions() {
  const [expandedMed, setExpandedMed] = useState<number | null>(null);
  const [showAddForm, setShowAddForm] = useState(false);

  const takenToday = activeMeds.filter((m) => m.taken).length;

  return (
    <div style={{ background: C.bg, paddingBottom: "24px", fontFamily: '"Open Sans", sans-serif' }}>
      {/* Header */}
      <div style={{ background: `linear-gradient(135deg, #8b6fa0 0%, #7a5c90 100%)`, padding: "20px 20px 32px", position: "relative", overflow: "hidden" }}>
        <div style={{ position: "absolute", top: "-20px", right: "-20px", width: "100px", height: "100px", borderRadius: "50px", background: "rgba(255,255,255,0.1)" }} />
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <div>
            <h1 style={{ color: "white", fontSize: "22px", fontWeight: "700", margin: "0 0 4px" }}>Prescriptions</h1>
            <p style={{ color: "rgba(255,255,255,0.8)", fontSize: "13px", margin: 0 }}>Medications & refill tracker</p>
          </div>
          <button
            onClick={() => setShowAddForm(true)}
            style={{ background: "rgba(255,255,255,0.25)", border: "none", borderRadius: "14px", padding: "10px 16px", cursor: "pointer", display: "flex", alignItems: "center", gap: "6px" }}
          >
            <Plus size={18} color="white" />
            <span style={{ color: "white", fontSize: "14px", fontWeight: "600", fontFamily: '"Open Sans", sans-serif' }}>Add</span>
          </button>
        </div>
      </div>

      {/* Today's Summary */}
      <div style={{ margin: "-16px 16px 16px", position: "relative", zIndex: 10 }}>
        <div style={{ background: C.card, borderRadius: "20px", padding: "16px", boxShadow: "0 4px 16px rgba(84,70,58,0.1)" }}>
          <p style={{ fontSize: "12px", fontWeight: "700", color: C.textSecondary, textTransform: "uppercase", letterSpacing: "0.5px", margin: "0 0 12px" }}>Today's Doses</p>
          <div style={{ display: "flex", gap: "8px" }}>
            {activeMeds.map((med, i) => (
              <div key={i} style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", gap: "4px" }}>
                <div
                  style={{
                    width: "40px",
                    height: "40px",
                    borderRadius: "12px",
                    background: med.taken ? med.color : C.bg,
                    border: `2px solid ${med.taken ? med.color : C.border}`,
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    fontSize: "16px",
                  }}
                >
                  {med.taken ? <CheckCircle2 size={18} color="white" /> : <span style={{ fontSize: "14px" }}>💊</span>}
                </div>
                <span style={{ fontSize: "10px", color: C.textSecondary, textAlign: "center", lineHeight: "1.2", maxWidth: "50px" }}>{med.name.split(" ")[0]}</span>
              </div>
            ))}
          </div>
          <div style={{ marginTop: "12px" }}>
            <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "4px" }}>
              <span style={{ fontSize: "13px", color: C.textSecondary }}>Progress today</span>
              <span style={{ fontSize: "13px", color: "#8b6fa0", fontWeight: "600" }}>{takenToday}/{activeMeds.length}</span>
            </div>
            <div style={{ height: "6px", background: C.border, borderRadius: "3px" }}>
              <div style={{ height: "100%", width: `${(takenToday / activeMeds.length) * 100}%`, background: "#8b6fa0", borderRadius: "3px" }} />
            </div>
          </div>
        </div>
      </div>

      {/* Refill Alert */}
      <div style={{ padding: "0 16px 16px" }}>
        <div style={{ background: "#fff3e0", borderRadius: "14px", padding: "12px 14px", border: "1px solid #ffd180", display: "flex", alignItems: "center", gap: "10px" }}>
          <AlertTriangle size={20} color="#c47c2f" style={{ flexShrink: 0 }} />
          <div>
            <p style={{ fontSize: "14px", fontWeight: "600", color: "#9a5e00", margin: "0 0 2px" }}>Refill needed soon</p>
            <p style={{ fontSize: "13px", color: "#b87820", margin: 0 }}>Lisinopril — 10 days remaining. Contact Dr. Chen.</p>
          </div>
        </div>
      </div>

      {/* Active Medications */}
      <div style={{ padding: "0 16px" }}>
        <p style={{ fontSize: "16px", fontWeight: "700", color: C.textPrimary, margin: "0 0 12px" }}>Active Medications</p>
        {activeMeds.map((med, i) => (
          <div
            key={i}
            style={{
              background: C.card,
              borderRadius: "20px",
              marginBottom: "10px",
              overflow: "hidden",
              boxShadow: "0 2px 12px rgba(84,70,58,0.07)",
              borderLeft: `4px solid ${med.color}`,
            }}
          >
            <button
              onClick={() => setExpandedMed(expandedMed === i ? null : i)}
              style={{ width: "100%", padding: "14px 16px", background: "none", border: "none", cursor: "pointer", display: "flex", alignItems: "center", gap: "12px", fontFamily: '"Open Sans", sans-serif' }}
            >
              <div style={{ width: "44px", height: "44px", borderRadius: "14px", background: `${med.color}18`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: "20px", flexShrink: 0 }}>
                {med.icon}
              </div>
              <div style={{ flex: 1, textAlign: "left" }}>
                <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                  <p style={{ fontSize: "15px", fontWeight: "700", color: C.textPrimary, margin: 0 }}>{med.name}</p>
                  <span style={{ fontSize: "13px", fontWeight: "600", color: med.color }}>{med.dose}</span>
                </div>
                <p style={{ fontSize: "13px", color: C.textSecondary, margin: "2px 0 0" }}>{med.frequency} · {med.timing}</p>
                <p style={{ fontSize: "12px", color: C.textSecondary, margin: "2px 0 0" }}>For: {med.reason}</p>
              </div>
              <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-end", gap: "4px" }}>
                {med.taken ? (
                  <div style={{ background: "#eef8f1", borderRadius: "8px", padding: "3px 8px", display: "flex", alignItems: "center", gap: "3px" }}>
                    <CheckCircle2 size={12} color="#5dab6f" />
                    <span style={{ fontSize: "11px", color: "#5dab6f", fontWeight: "600" }}>Taken</span>
                  </div>
                ) : (
                  <div style={{ background: "#fff3e0", borderRadius: "8px", padding: "3px 8px", display: "flex", alignItems: "center", gap: "3px" }}>
                    <Clock size={12} color="#c47c2f" />
                    <span style={{ fontSize: "11px", color: "#c47c2f", fontWeight: "600" }}>Due</span>
                  </div>
                )}
                <ChevronRight size={14} color={C.border} style={{ transform: expandedMed === i ? "rotate(90deg)" : "none", transition: "transform 0.2s" }} />
              </div>
            </button>

            {expandedMed === i && (
              <div style={{ padding: "0 16px 16px", borderTop: `1px solid ${C.border}` }}>
                <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "8px", marginTop: "12px", marginBottom: "10px" }}>
                  <div style={{ background: C.bg, borderRadius: "12px", padding: "10px" }}>
                    <p style={{ fontSize: "11px", color: C.textSecondary, margin: "0 0 3px", fontWeight: "600" }}>PRESCRIBED BY</p>
                    <p style={{ fontSize: "13px", color: C.textPrimary, margin: 0, fontWeight: "500" }}>{med.doctor}</p>
                  </div>
                  <div style={{ background: C.bg, borderRadius: "12px", padding: "10px" }}>
                    <p style={{ fontSize: "11px", color: C.textSecondary, margin: "0 0 3px", fontWeight: "600" }}>STARTED</p>
                    <p style={{ fontSize: "13px", color: C.textPrimary, margin: 0, fontWeight: "500" }}>{med.startDate}</p>
                  </div>
                  <div style={{ background: med.daysLeft <= 14 ? "#fff3e0" : C.bg, borderRadius: "12px", padding: "10px" }}>
                    <p style={{ fontSize: "11px", color: C.textSecondary, margin: "0 0 3px", fontWeight: "600" }}>NEXT REFILL</p>
                    <p style={{ fontSize: "13px", color: med.daysLeft <= 14 ? "#c47c2f" : C.textPrimary, margin: 0, fontWeight: "600" }}>
                      {med.refillDate !== "Ongoing" ? `${med.refillDate} (${med.daysLeft}d)` : "Ongoing"}
                    </p>
                  </div>
                  <div style={{ background: C.bg, borderRadius: "12px", padding: "10px" }}>
                    <p style={{ fontSize: "11px", color: C.textSecondary, margin: "0 0 3px", fontWeight: "600" }}>STATUS</p>
                    <p style={{ fontSize: "13px", color: "#5dab6f", margin: 0, fontWeight: "600" }}>Active</p>
                  </div>
                </div>

                <div style={{ background: C.pink50, borderRadius: "12px", padding: "10px 12px", marginBottom: "8px", border: `1px solid ${C.primaryLight}55` }}>
                  <p style={{ fontSize: "12px", fontWeight: "700", color: C.primary, margin: "0 0 4px", textTransform: "uppercase", letterSpacing: "0.5px" }}>Instructions</p>
                  <p style={{ fontSize: "13px", color: C.textPrimary, margin: 0, lineHeight: "1.5" }}>{med.instructions}</p>
                </div>

                <div style={{ background: "#fff8e8", borderRadius: "12px", padding: "10px 12px", marginBottom: "12px", border: "1px solid #ffe0a055" }}>
                  <p style={{ fontSize: "12px", fontWeight: "700", color: "#c47c2f", margin: "0 0 4px", textTransform: "uppercase", letterSpacing: "0.5px" }}>Side Effects to Watch</p>
                  <p style={{ fontSize: "13px", color: C.textPrimary, margin: 0, lineHeight: "1.5" }}>{med.sideEffects}</p>
                </div>

                {med.daysLeft <= 14 && (
                  <button style={{ width: "100%", padding: "12px", background: C.primary, border: "none", borderRadius: "12px", display: "flex", alignItems: "center", justifyContent: "center", gap: "8px", cursor: "pointer" }}>
                    <RefreshCw size={16} color="white" />
                    <span style={{ fontSize: "14px", fontWeight: "600", color: "white", fontFamily: '"Open Sans", sans-serif' }}>Request Refill</span>
                  </button>
                )}
              </div>
            )}
          </div>
        ))}
      </div>

      {/* Past Medications */}
      <div style={{ padding: "16px 16px 0" }}>
        <p style={{ fontSize: "16px", fontWeight: "700", color: C.textPrimary, margin: "0 0 12px" }}>Past Medications</p>
        {pastMeds.map((med, i) => (
          <div key={i} style={{ background: C.card, borderRadius: "14px", padding: "14px", marginBottom: "8px", display: "flex", justifyContent: "space-between", alignItems: "center", opacity: 0.7 }}>
            <div>
              <p style={{ fontSize: "14px", fontWeight: "600", color: C.textPrimary, margin: "0 0 2px" }}>{med.name}</p>
              <p style={{ fontSize: "12px", color: C.textSecondary, margin: "0 0 2px" }}>{med.reason}</p>
              <p style={{ fontSize: "12px", color: C.textSecondary, margin: 0 }}>{med.period} · {med.doctor}</p>
            </div>
            <div style={{ background: "#eef8f1", borderRadius: "8px", padding: "4px 10px" }}>
              <span style={{ fontSize: "12px", color: "#5dab6f", fontWeight: "600" }}>{med.status}</span>
            </div>
          </div>
        ))}
      </div>

      {/* Add Medication Modal */}
      {showAddForm && (
        <div style={{ position: "absolute", inset: 0, zIndex: 150, background: "rgba(84,70,58,0.5)", display: "flex", alignItems: "flex-end" }}>
          <div style={{ background: C.card, borderRadius: "24px 24px 0 0", padding: "20px", width: "100%", boxShadow: "0 -4px 30px rgba(0,0,0,0.15)" }}>
            <div style={{ display: "flex", justifyContent: "center", marginBottom: "16px" }}>
              <div style={{ width: "40px", height: "4px", background: C.border, borderRadius: "2px" }} />
            </div>
            <h3 style={{ margin: "0 0 16px", color: C.textPrimary, fontSize: "18px", fontWeight: "700" }}>Add Prescription</h3>
            {[
              { label: "Medication Name", placeholder: "e.g. Lisinopril" },
              { label: "Dose", placeholder: "e.g. 10 mg" },
              { label: "Frequency", placeholder: "e.g. Once daily" },
              { label: "Reason / Condition", placeholder: "e.g. Blood pressure" },
              { label: "Prescribing Doctor", placeholder: "e.g. Dr. Sarah Chen" },
            ].map((field) => (
              <div key={field.label} style={{ marginBottom: "10px" }}>
                <label style={{ fontSize: "14px", fontWeight: "600", color: C.textPrimary, display: "block", marginBottom: "5px" }}>{field.label}</label>
                <input
                  placeholder={field.placeholder}
                  style={{ width: "100%", padding: "12px 14px", border: `1.5px solid ${C.border}`, borderRadius: "12px", fontSize: "15px", fontFamily: '"Open Sans", sans-serif', color: C.textPrimary, background: C.bg, outline: "none", boxSizing: "border-box" }}
                />
              </div>
            ))}
            <div style={{ display: "flex", gap: "10px", marginTop: "8px" }}>
              <button onClick={() => setShowAddForm(false)} style={{ flex: 1, padding: "14px", background: C.bg, border: `1.5px solid ${C.border}`, borderRadius: "14px", fontSize: "15px", fontWeight: "600", color: C.textSecondary, cursor: "pointer", fontFamily: '"Open Sans", sans-serif' }}>Cancel</button>
              <button onClick={() => setShowAddForm(false)} style={{ flex: 2, padding: "14px", background: "#8b6fa0", border: "none", borderRadius: "14px", fontSize: "15px", fontWeight: "600", color: "white", cursor: "pointer", fontFamily: '"Open Sans", sans-serif' }}>Save</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
