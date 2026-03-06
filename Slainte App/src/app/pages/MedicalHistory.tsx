import { useState } from "react";
import { FileText, ChevronDown, Plus, AlertTriangle, Heart, Scissors, Shield, Users, Syringe } from "lucide-react";
import { C } from "../constants/colors";

type Section = "conditions" | "surgeries" | "allergies" | "immunizations" | "family";

const sections: { id: Section; label: string; icon: any; color: string; count: number }[] = [
  { id: "conditions", label: "Medical Conditions", icon: Heart, color: C.primary, count: 4 },
  { id: "surgeries", label: "Surgeries & Procedures", icon: Scissors, color: C.darkMid, count: 2 },
  { id: "allergies", label: "Allergies & Reactions", icon: AlertTriangle, color: "#c47c2f", count: 2 },
  { id: "immunizations", label: "Immunizations", icon: Syringe, color: "#5dab6f", count: 4 },
  { id: "family", label: "Family History", icon: Users, color: "#5a88c4", count: 3 },
];

const sectionData: Record<Section, any[]> = {
  conditions: [
    {
      name: "Hypertension (High Blood Pressure)",
      diagnosed: "March 2023",
      status: "Ongoing — managed",
      doctor: "Dr. Sarah Chen",
      notes: "Well-controlled on Lisinopril 10mg. Target BP < 130/80. Lifestyle modifications recommended.",
      severity: "moderate",
    },
    {
      name: "Pre-diabetes (Impaired Fasting Glucose)",
      diagnosed: "February 2026",
      status: "Ongoing — monitoring",
      doctor: "Dr. Sarah Chen",
      notes: "HbA1c 5.9%. Started on low-dose Metformin and dietary modifications. Review in 3 months.",
      severity: "mild",
    },
    {
      name: "Hypercholesterolaemia",
      diagnosed: "June 2024",
      status: "Ongoing — managed",
      doctor: "Dr. Sarah Chen",
      notes: "Total cholesterol 5.2 mmol/L. On Atorvastatin 20mg. Dietary advice given. Review annually.",
      severity: "moderate",
    },
    {
      name: "Mild Sensorineural Hearing Loss (Right Ear)",
      diagnosed: "November 2025",
      status: "Ongoing — monitoring",
      doctor: "Dr. Mark Thompson",
      notes: "High-frequency loss at 4–8 kHz. Annual audiometry recommended. No hearing aid required.",
      severity: "mild",
    },
  ],
  surgeries: [
    {
      procedure: "Appendectomy",
      date: "September 1985",
      hospital: "St. James's Hospital",
      surgeon: "Unknown",
      notes: "Emergency appendix removal. Uncomplicated recovery. No long-term complications.",
      outcome: "Full recovery",
    },
    {
      procedure: "Knee Arthroscopy (Right Knee)",
      date: "April 2015",
      hospital: "National Orthopaedic Hospital",
      surgeon: "Mr. David O'Brien",
      notes: "Meniscal tear repair. Physiotherapy completed 8 weeks post-op. Good functional outcome.",
      outcome: "Full recovery",
    },
  ],
  allergies: [
    {
      allergen: "Penicillin",
      type: "Medication",
      reaction: "Generalised skin rash, itching",
      severity: "Moderate",
      firstReported: "1992",
      notes: "Documented allergy. All alternative antibiotics should be used. Alert on medical record.",
    },
    {
      allergen: "Aspirin / NSAIDs",
      type: "Medication",
      reaction: "Stomach pain, nausea, GI upset",
      severity: "Mild",
      firstReported: "2010",
      notes: "Use paracetamol/acetaminophen as alternative for pain relief.",
    },
  ],
  immunizations: [
    { vaccine: "Influenza (Flu) Vaccine", date: "October 2025", provider: "Greenfield Family Practice", nextDue: "Oct 2026" },
    { vaccine: "COVID-19 Booster (Updated)", date: "September 2025", provider: "Greenfield Family Practice", nextDue: "As advised" },
    { vaccine: "Shingles Vaccine (Shingrix — Dose 1)", date: "June 2024", provider: "Greenfield Family Practice", nextDue: "Dose 2: Jun 2025 ✓" },
    { vaccine: "Pneumococcal Vaccine (PCV23)", date: "March 2023", provider: "Greenfield Family Practice", nextDue: "Single dose (complete)" },
  ],
  family: [
    {
      relation: "Father (Deceased, age 74)",
      conditions: ["Type 2 Diabetes (diagnosed age 58)", "Coronary Artery Disease", "Myocardial Infarction (age 72)"],
      notes: "Paternal history of cardiovascular disease and diabetes — relevant risk factors for Margaret.",
    },
    {
      relation: "Mother (Alive, age 88)",
      conditions: ["Breast Cancer (diagnosed age 65, treated — remission)", "Osteoporosis (diagnosed age 72)", "Hypertension"],
      notes: "Maternal breast cancer history. Bone density monitoring recommended.",
    },
    {
      relation: "Sibling — Sister (age 62)",
      conditions: ["Type 2 Diabetes", "Hypothyroidism"],
      notes: "TSH monitoring recommended annually given family history.",
    },
  ],
};

const severityColors: Record<string, string> = {
  mild: "#5dab6f",
  moderate: "#c47c2f",
  severe: "#c75050",
};

export function MedicalHistory() {
  const [openSection, setOpenSection] = useState<Section | null>("conditions");

  const toggleSection = (id: Section) => {
    setOpenSection(openSection === id ? null : id);
  };

  return (
    <div style={{ background: C.bg, paddingBottom: "24px", fontFamily: '"Open Sans", sans-serif' }}>
      {/* Header */}
      <div style={{ background: `linear-gradient(135deg, #c47c2f 0%, #a85e10 100%)`, padding: "20px 20px 32px", position: "relative", overflow: "hidden" }}>
        <div style={{ position: "absolute", top: "-20px", right: "-20px", width: "100px", height: "100px", borderRadius: "50px", background: "rgba(255,255,255,0.1)" }} />
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <div>
            <h1 style={{ color: "white", fontSize: "22px", fontWeight: "700", margin: "0 0 4px" }}>Medical History</h1>
            <p style={{ color: "rgba(255,255,255,0.8)", fontSize: "13px", margin: 0 }}>Margaret Williams · DOB: 12 Jun 1960</p>
          </div>
          <button style={{ background: "rgba(255,255,255,0.25)", border: "none", borderRadius: "14px", padding: "10px 16px", cursor: "pointer", display: "flex", alignItems: "center", gap: "6px" }}>
            <Plus size={18} color="white" />
            <span style={{ color: "white", fontSize: "14px", fontWeight: "600", fontFamily: '"Open Sans", sans-serif' }}>Add</span>
          </button>
        </div>
      </div>

      {/* Emergency Card */}
      <div style={{ margin: "-16px 16px 16px", position: "relative", zIndex: 10 }}>
        <div style={{ background: "#fff3f3", borderRadius: "18px", padding: "14px 16px", border: "1px solid #ffc8c8", boxShadow: "0 4px 16px rgba(199,95,113,0.12)" }}>
          <div style={{ display: "flex", alignItems: "center", gap: "8px", marginBottom: "10px" }}>
            <Shield size={18} color="#c75050" />
            <p style={{ fontSize: "14px", fontWeight: "700", color: "#c75050", margin: 0 }}>Emergency Health Summary</p>
          </div>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "6px" }}>
            {[
              { label: "Blood Type", value: "A+" },
              { label: "Allergies", value: "Penicillin, Aspirin" },
              { label: "Key Conditions", value: "Hypertension, Pre-diabetes" },
              { label: "Emergency Contact", value: "John Williams · 087 xxx xxxx" },
            ].map((item) => (
              <div key={item.label} style={{ background: "white", borderRadius: "10px", padding: "8px 10px" }}>
                <p style={{ fontSize: "10px", fontWeight: "700", color: "#c75050", margin: "0 0 2px", textTransform: "uppercase", letterSpacing: "0.3px" }}>{item.label}</p>
                <p style={{ fontSize: "12px", color: C.textPrimary, margin: 0, fontWeight: "500" }}>{item.value}</p>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Accordion Sections */}
      <div style={{ padding: "0 16px" }}>
        {sections.map(({ id, label, icon: Icon, color, count }) => (
          <div
            key={id}
            style={{
              background: C.card,
              borderRadius: "18px",
              marginBottom: "8px",
              overflow: "hidden",
              boxShadow: "0 2px 10px rgba(84,70,58,0.06)",
            }}
          >
            <button
              onClick={() => toggleSection(id)}
              style={{
                width: "100%",
                padding: "16px",
                background: openSection === id ? `${color}0d` : "transparent",
                border: "none",
                cursor: "pointer",
                display: "flex",
                alignItems: "center",
                gap: "12px",
                fontFamily: '"Open Sans", sans-serif',
              }}
            >
              <div style={{ width: "40px", height: "40px", borderRadius: "12px", background: `${color}18`, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
                <Icon size={20} color={color} />
              </div>
              <div style={{ flex: 1, textAlign: "left" }}>
                <p style={{ fontSize: "15px", fontWeight: "700", color: C.textPrimary, margin: 0 }}>{label}</p>
                <p style={{ fontSize: "12px", color: C.textSecondary, margin: "2px 0 0" }}>{count} {count === 1 ? "entry" : "entries"}</p>
              </div>
              <ChevronDown
                size={18}
                color={C.textSecondary}
                style={{ transform: openSection === id ? "rotate(180deg)" : "none", transition: "transform 0.25s" }}
              />
            </button>

            {openSection === id && (
              <div style={{ borderTop: `1px solid ${C.border}` }}>
                {/* Conditions */}
                {id === "conditions" && (sectionData.conditions as any[]).map((item, i) => (
                  <div key={i} style={{ padding: "14px 16px", borderBottom: i < sectionData.conditions.length - 1 ? `1px solid ${C.border}` : "none" }}>
                    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: "6px" }}>
                      <p style={{ fontSize: "14px", fontWeight: "700", color: C.textPrimary, margin: 0, flex: 1, marginRight: "8px" }}>{item.name}</p>
                      <span style={{ fontSize: "11px", fontWeight: "600", color: severityColors[item.severity], background: `${severityColors[item.severity]}18`, padding: "2px 8px", borderRadius: "6px", flexShrink: 0 }}>
                        {item.severity.charAt(0).toUpperCase() + item.severity.slice(1)}
                      </span>
                    </div>
                    <p style={{ fontSize: "12px", color: C.textSecondary, margin: "0 0 4px" }}>Diagnosed: {item.diagnosed} · {item.doctor}</p>
                    <div style={{ background: C.bg, borderRadius: "10px", padding: "8px 10px" }}>
                      <p style={{ fontSize: "12px", color: C.primary, fontWeight: "600", margin: "0 0 2px" }}>Status: {item.status}</p>
                      <p style={{ fontSize: "12px", color: C.textPrimary, margin: 0, lineHeight: "1.4" }}>{item.notes}</p>
                    </div>
                  </div>
                ))}

                {/* Surgeries */}
                {id === "surgeries" && (sectionData.surgeries as any[]).map((item, i) => (
                  <div key={i} style={{ padding: "14px 16px", borderBottom: i < sectionData.surgeries.length - 1 ? `1px solid ${C.border}` : "none" }}>
                    <p style={{ fontSize: "14px", fontWeight: "700", color: C.textPrimary, margin: "0 0 4px" }}>{item.procedure}</p>
                    <p style={{ fontSize: "12px", color: C.textSecondary, margin: "0 0 4px" }}>{item.date} · {item.hospital}</p>
                    <div style={{ background: C.bg, borderRadius: "10px", padding: "8px 10px" }}>
                      <p style={{ fontSize: "12px", color: "#5dab6f", fontWeight: "600", margin: "0 0 2px" }}>Outcome: {item.outcome}</p>
                      <p style={{ fontSize: "12px", color: C.textPrimary, margin: 0, lineHeight: "1.4" }}>{item.notes}</p>
                    </div>
                  </div>
                ))}

                {/* Allergies */}
                {id === "allergies" && (sectionData.allergies as any[]).map((item, i) => (
                  <div key={i} style={{ padding: "14px 16px", borderBottom: i < sectionData.allergies.length - 1 ? `1px solid ${C.border}` : "none" }}>
                    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: "6px" }}>
                      <div>
                        <p style={{ fontSize: "14px", fontWeight: "700", color: "#c75050", margin: "0 0 2px" }}>⚠️ {item.allergen}</p>
                        <p style={{ fontSize: "12px", color: C.textSecondary, margin: 0 }}>{item.type} · First noted: {item.firstReported}</p>
                      </div>
                      <span style={{ fontSize: "11px", fontWeight: "600", color: "#c47c2f", background: "#fff3e0", padding: "2px 8px", borderRadius: "6px" }}>{item.severity}</span>
                    </div>
                    <div style={{ background: "#fff3f3", borderRadius: "10px", padding: "8px 10px", marginBottom: "6px" }}>
                      <p style={{ fontSize: "12px", fontWeight: "600", color: "#c75050", margin: "0 0 2px" }}>Reaction: {item.reaction}</p>
                    </div>
                    <p style={{ fontSize: "12px", color: C.textPrimary, margin: 0, lineHeight: "1.4" }}>{item.notes}</p>
                  </div>
                ))}

                {/* Immunizations */}
                {id === "immunizations" && (sectionData.immunizations as any[]).map((item, i) => (
                  <div key={i} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "12px 16px", borderBottom: i < sectionData.immunizations.length - 1 ? `1px solid ${C.border}` : "none" }}>
                    <div>
                      <p style={{ fontSize: "13px", fontWeight: "600", color: C.textPrimary, margin: "0 0 2px" }}>{item.vaccine}</p>
                      <p style={{ fontSize: "12px", color: C.textSecondary, margin: "0 0 2px" }}>{item.date}</p>
                      <p style={{ fontSize: "11px", color: "#5dab6f", margin: 0 }}>Next: {item.nextDue}</p>
                    </div>
                    <div style={{ width: "28px", height: "28px", borderRadius: "14px", background: "#eef8f1", display: "flex", alignItems: "center", justifyContent: "center" }}>
                      <span style={{ fontSize: "14px" }}>✓</span>
                    </div>
                  </div>
                ))}

                {/* Family History */}
                {id === "family" && (sectionData.family as any[]).map((item, i) => (
                  <div key={i} style={{ padding: "14px 16px", borderBottom: i < sectionData.family.length - 1 ? `1px solid ${C.border}` : "none" }}>
                    <p style={{ fontSize: "14px", fontWeight: "700", color: "#5a88c4", margin: "0 0 6px" }}>{item.relation}</p>
                    <div style={{ background: "#f0f6ff", borderRadius: "10px", padding: "8px 10px", marginBottom: "6px" }}>
                      {item.conditions.map((c: string, ci: number) => (
                        <p key={ci} style={{ fontSize: "12px", color: C.textPrimary, margin: ci > 0 ? "3px 0 0" : 0 }}>• {c}</p>
                      ))}
                    </div>
                    <p style={{ fontSize: "12px", color: C.textSecondary, margin: 0, lineHeight: "1.4", fontStyle: "italic" }}>{item.notes}</p>
                  </div>
                ))}
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
