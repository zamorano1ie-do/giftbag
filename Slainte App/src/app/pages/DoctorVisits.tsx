import { useState } from "react";
import { Stethoscope, Plus, Calendar, MapPin, FileText, ChevronRight, Clock, Video } from "lucide-react";
import { C } from "../constants/colors";

const upcomingVisits = [
  {
    doctor: "Dr. Sarah Chen",
    specialty: "General Practitioner",
    clinic: "Greenfield Family Practice",
    date: "Saturday, Mar 8",
    time: "10:30 AM",
    type: "in-person",
    reason: "Annual Health Checkup",
    avatar: "👩‍⚕️",
    color: C.primary,
  },
  {
    doctor: "Dr. James Williams",
    specialty: "Cardiologist",
    clinic: "Heart & Vascular Centre",
    date: "Thursday, Mar 19",
    time: "2:00 PM",
    type: "video",
    reason: "6-month Follow-up",
    avatar: "👨‍⚕️",
    color: "#5a88c4",
  },
];

const pastVisits = [
  {
    doctor: "Dr. Sarah Chen",
    specialty: "General Practitioner",
    clinic: "Greenfield Family Practice",
    date: "Feb 15, 2026",
    reason: "Blood pressure review & blood test referral",
    notes: "BP still slightly elevated at 130/83. Increased Lisinopril monitoring frequency. Referred for blood tests. Results discussed at follow-up.",
    prescriptions: ["Lisinopril 10mg — continued", "Metformin 500mg — NEW"],
    avatar: "👩‍⚕️",
    color: C.primary,
  },
  {
    doctor: "Dr. Aisha Patel",
    specialty: "Optometrist",
    clinic: "City Eye Clinic",
    date: "Jan 10, 2026",
    reason: "Annual eye examination",
    notes: "Prescription unchanged from last year. Mild dry eye noted. Recommended lubricating eye drops. No signs of glaucoma or macular degeneration.",
    prescriptions: [],
    avatar: "👩‍⚕️",
    color: "#8b6fa0",
  },
  {
    doctor: "Dr. James Williams",
    specialty: "Cardiologist",
    clinic: "Heart & Vascular Centre",
    date: "Jan 20, 2026",
    reason: "Cardiac follow-up",
    notes: "ECG normal sinus rhythm. Echocardiogram showed no structural abnormalities. Continue current medications. Excellent progress with blood pressure management.",
    prescriptions: [],
    avatar: "👨‍⚕️",
    color: "#5a88c4",
  },
  {
    doctor: "Dr. Sarah Chen",
    specialty: "General Practitioner",
    clinic: "Greenfield Family Practice",
    date: "Dec 8, 2025",
    reason: "Acute consultation — respiratory symptoms",
    notes: "Presented with cough and mild fever for 4 days. Chest clear on auscultation. Likely viral upper respiratory tract infection. Prescribed 5-day antibiotic course as precaution.",
    prescriptions: ["Amoxicillin 500mg — 5 days (completed)"],
    avatar: "👩‍⚕️",
    color: C.primary,
  },
  {
    doctor: "Dr. Mark Thompson",
    specialty: "Audiologist",
    clinic: "St. Mary's ENT Clinic",
    date: "Nov 14, 2025",
    reason: "Routine hearing assessment",
    notes: "Mild high-frequency loss in right ear. Left ear within normal limits. Annual monitoring recommended. No hearing aid required at this stage.",
    prescriptions: [],
    avatar: "👨‍⚕️",
    color: C.sageDark,
  },
];

export function DoctorVisits() {
  const [expandedVisit, setExpandedVisit] = useState<number | null>(null);
  const [showAddForm, setShowAddForm] = useState(false);

  return (
    <div style={{ background: C.bg, paddingBottom: "24px", fontFamily: '"Open Sans", sans-serif' }}>
      {/* Header */}
      <div style={{ background: `linear-gradient(135deg, ${C.darkMid} 0%, ${C.dark} 100%)`, padding: "20px 20px 32px", position: "relative", overflow: "hidden" }}>
        <div style={{ position: "absolute", top: "-20px", right: "-20px", width: "100px", height: "100px", borderRadius: "50px", background: "rgba(255,255,255,0.08)" }} />
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <div>
            <h1 style={{ color: "white", fontSize: "22px", fontWeight: "700", margin: "0 0 4px" }}>Doctor Visits</h1>
            <p style={{ color: "rgba(255,255,255,0.7)", fontSize: "13px", margin: 0 }}>Appointments & consultations</p>
          </div>
          <button
            onClick={() => setShowAddForm(true)}
            style={{ background: "rgba(255,255,255,0.2)", border: "none", borderRadius: "14px", padding: "10px 16px", cursor: "pointer", display: "flex", alignItems: "center", gap: "6px" }}
          >
            <Plus size={18} color="white" />
            <span style={{ color: "white", fontSize: "14px", fontWeight: "600", fontFamily: '"Open Sans", sans-serif' }}>Add</span>
          </button>
        </div>
      </div>

      {/* Upcoming */}
      <div style={{ margin: "-16px 16px 16px", position: "relative", zIndex: 10 }}>
        <p style={{ fontSize: "13px", fontWeight: "700", color: C.textSecondary, textTransform: "uppercase", letterSpacing: "0.5px", margin: "0 0 10px" }}>Upcoming</p>
        {upcomingVisits.map((visit, i) => (
          <div
            key={i}
            style={{
              background: C.card,
              borderRadius: "20px",
              padding: "16px",
              marginBottom: "10px",
              boxShadow: "0 4px 16px rgba(84,70,58,0.1)",
              borderLeft: `4px solid ${visit.color}`,
            }}
          >
            <div style={{ display: "flex", alignItems: "flex-start", gap: "12px" }}>
              <div style={{ width: "44px", height: "44px", borderRadius: "22px", background: `${visit.color}18`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: "22px", flexShrink: 0 }}>
                {visit.avatar}
              </div>
              <div style={{ flex: 1 }}>
                <p style={{ fontSize: "15px", fontWeight: "700", color: C.textPrimary, margin: "0 0 2px" }}>{visit.doctor}</p>
                <p style={{ fontSize: "13px", color: C.textSecondary, margin: "0 0 8px" }}>{visit.specialty} · {visit.clinic}</p>
                <div style={{ display: "flex", flexWrap: "wrap", gap: "6px" }}>
                  <div style={{ display: "flex", alignItems: "center", gap: "4px", background: C.bg, borderRadius: "8px", padding: "4px 8px" }}>
                    <Calendar size={13} color={visit.color} />
                    <span style={{ fontSize: "12px", color: C.textPrimary, fontWeight: "500" }}>{visit.date}</span>
                  </div>
                  <div style={{ display: "flex", alignItems: "center", gap: "4px", background: C.bg, borderRadius: "8px", padding: "4px 8px" }}>
                    <Clock size={13} color={visit.color} />
                    <span style={{ fontSize: "12px", color: C.textPrimary, fontWeight: "500" }}>{visit.time}</span>
                  </div>
                  {visit.type === "video" && (
                    <div style={{ display: "flex", alignItems: "center", gap: "4px", background: "#e8f4ff", borderRadius: "8px", padding: "4px 8px" }}>
                      <Video size={13} color="#5a88c4" />
                      <span style={{ fontSize: "12px", color: "#5a88c4", fontWeight: "600" }}>Video</span>
                    </div>
                  )}
                </div>
                <p style={{ fontSize: "13px", color: C.textSecondary, margin: "8px 0 0" }}>{visit.reason}</p>
              </div>
            </div>
            <div style={{ display: "flex", gap: "8px", marginTop: "12px" }}>
              <button style={{ flex: 1, padding: "10px", background: `${visit.color}18`, border: "none", borderRadius: "12px", fontSize: "13px", fontWeight: "600", color: visit.color, cursor: "pointer", fontFamily: '"Open Sans", sans-serif' }}>
                Directions
              </button>
              <button style={{ flex: 1, padding: "10px", background: visit.color, border: "none", borderRadius: "12px", fontSize: "13px", fontWeight: "600", color: "white", cursor: "pointer", fontFamily: '"Open Sans", sans-serif' }}>
                {visit.type === "video" ? "Join Call" : "Confirm"}
              </button>
            </div>
          </div>
        ))}
      </div>

      {/* Past Visits */}
      <div style={{ padding: "0 16px" }}>
        <p style={{ fontSize: "13px", fontWeight: "700", color: C.textSecondary, textTransform: "uppercase", letterSpacing: "0.5px", margin: "0 0 10px" }}>Past Visits</p>
        {pastVisits.map((visit, i) => (
          <div
            key={i}
            style={{
              background: C.card,
              borderRadius: "18px",
              marginBottom: "10px",
              overflow: "hidden",
              boxShadow: "0 2px 10px rgba(84,70,58,0.06)",
            }}
          >
            <button
              onClick={() => setExpandedVisit(expandedVisit === i ? null : i)}
              style={{ width: "100%", padding: "14px 16px", background: "none", border: "none", cursor: "pointer", display: "flex", alignItems: "center", gap: "12px", fontFamily: '"Open Sans", sans-serif' }}
            >
              <div style={{ width: "38px", height: "38px", borderRadius: "19px", background: `${visit.color}18`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: "18px", flexShrink: 0 }}>
                {visit.avatar}
              </div>
              <div style={{ flex: 1, textAlign: "left" }}>
                <p style={{ fontSize: "14px", fontWeight: "700", color: C.textPrimary, margin: "0 0 2px" }}>{visit.doctor}</p>
                <p style={{ fontSize: "12px", color: C.textSecondary, margin: 0 }}>{visit.date} · {visit.specialty}</p>
              </div>
              <ChevronRight
                size={16}
                color={C.textSecondary}
                style={{ transform: expandedVisit === i ? "rotate(90deg)" : "none", transition: "transform 0.2s", flexShrink: 0 }}
              />
            </button>

            {expandedVisit === i && (
              <div style={{ padding: "0 16px 16px", borderTop: `1px solid ${C.border}` }}>
                <div style={{ display: "flex", alignItems: "center", gap: "6px", marginTop: "12px", marginBottom: "8px" }}>
                  <MapPin size={14} color={C.textSecondary} />
                  <span style={{ fontSize: "13px", color: C.textSecondary }}>{visit.clinic}</span>
                </div>
                <div style={{ background: C.bg, borderRadius: "12px", padding: "12px", marginBottom: "10px" }}>
                  <p style={{ fontSize: "12px", fontWeight: "700", color: C.textSecondary, textTransform: "uppercase", letterSpacing: "0.5px", margin: "0 0 6px" }}>Reason</p>
                  <p style={{ fontSize: "13px", color: C.primary, fontWeight: "600", margin: 0 }}>{visit.reason}</p>
                </div>
                <div style={{ background: C.bg, borderRadius: "12px", padding: "12px", marginBottom: "10px" }}>
                  <p style={{ fontSize: "12px", fontWeight: "700", color: C.textSecondary, textTransform: "uppercase", letterSpacing: "0.5px", margin: "0 0 6px" }}>Notes</p>
                  <p style={{ fontSize: "13px", color: C.textPrimary, margin: 0, lineHeight: "1.5" }}>{visit.notes}</p>
                </div>
                {visit.prescriptions.length > 0 && (
                  <div style={{ background: C.pink50, borderRadius: "12px", padding: "12px", border: `1px solid ${C.primaryLight}` }}>
                    <p style={{ fontSize: "12px", fontWeight: "700", color: C.primary, textTransform: "uppercase", letterSpacing: "0.5px", margin: "0 0 6px" }}>Prescriptions</p>
                    {visit.prescriptions.map((p, pi) => (
                      <p key={pi} style={{ fontSize: "13px", color: C.textPrimary, margin: pi > 0 ? "4px 0 0" : 0 }}>• {p}</p>
                    ))}
                  </div>
                )}
              </div>
            )}
          </div>
        ))}
      </div>

      {/* Add Visit Modal */}
      {showAddForm && (
        <div style={{ position: "absolute", inset: 0, zIndex: 150, background: "rgba(84,70,58,0.5)", display: "flex", alignItems: "flex-end" }}>
          <div style={{ background: C.card, borderRadius: "24px 24px 0 0", padding: "20px", width: "100%", boxShadow: "0 -4px 30px rgba(0,0,0,0.15)" }}>
            <div style={{ display: "flex", justifyContent: "center", marginBottom: "16px" }}>
              <div style={{ width: "40px", height: "4px", background: C.border, borderRadius: "2px" }} />
            </div>
            <h3 style={{ margin: "0 0 16px", color: C.textPrimary, fontSize: "18px", fontWeight: "700" }}>Add Doctor Visit</h3>
            {[
              { label: "Doctor's Name", placeholder: "e.g. Dr. Sarah Chen" },
              { label: "Specialty / Clinic", placeholder: "e.g. GP, City Medical Centre" },
              { label: "Date of Visit", placeholder: "e.g. 5 March 2026", type: "date" },
              { label: "Reason for Visit", placeholder: "e.g. Annual checkup" },
            ].map((field) => (
              <div key={field.label} style={{ marginBottom: "12px" }}>
                <label style={{ fontSize: "14px", fontWeight: "600", color: C.textPrimary, display: "block", marginBottom: "6px" }}>{field.label}</label>
                <input
                  type={field.type || "text"}
                  placeholder={field.placeholder}
                  style={{ width: "100%", padding: "12px 14px", border: `1.5px solid ${C.border}`, borderRadius: "12px", fontSize: "15px", fontFamily: '"Open Sans", sans-serif', color: C.textPrimary, background: C.bg, outline: "none", boxSizing: "border-box" }}
                />
              </div>
            ))}
            <div style={{ marginBottom: "12px" }}>
              <label style={{ fontSize: "14px", fontWeight: "600", color: C.textPrimary, display: "block", marginBottom: "6px" }}>Notes</label>
              <textarea rows={3} placeholder="Doctor's notes, diagnoses, advice..." style={{ width: "100%", padding: "12px 14px", border: `1.5px solid ${C.border}`, borderRadius: "12px", fontSize: "15px", fontFamily: '"Open Sans", sans-serif', color: C.textPrimary, background: C.bg, outline: "none", boxSizing: "border-box", resize: "none" }} />
            </div>
            <div style={{ display: "flex", gap: "10px" }}>
              <button onClick={() => setShowAddForm(false)} style={{ flex: 1, padding: "14px", background: C.bg, border: `1.5px solid ${C.border}`, borderRadius: "14px", fontSize: "15px", fontWeight: "600", color: C.textSecondary, cursor: "pointer", fontFamily: '"Open Sans", sans-serif' }}>Cancel</button>
              <button onClick={() => setShowAddForm(false)} style={{ flex: 2, padding: "14px", background: C.dark, border: "none", borderRadius: "14px", fontSize: "15px", fontWeight: "600", color: "white", cursor: "pointer", fontFamily: '"Open Sans", sans-serif' }}>Save Visit</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
