import { Link } from "react-router";
import {
  Pill, FileText, BookOpen, Settings, ChevronRight,
  Phone, Share2, Download, Shield, User, Bell, HelpCircle,
  Activity, Stethoscope, FlaskConical
} from "lucide-react";
import { C } from "../constants/colors";

const mainLinks = [
  { path: "/prescriptions", icon: Pill, label: "Prescriptions", description: "Medications & refills", color: "#8b6fa0", bg: "#f3eef8" },
  { path: "/history", icon: FileText, label: "Medical History", description: "Conditions, allergies & more", color: "#c47c2f", bg: "#fdf3e7" },
  { path: "/guidance", icon: BookOpen, label: "Health Guidance", description: "Tips & health education", color: C.sageDark, bg: C.sage50 },
];

const tools = [
  { icon: Share2, label: "Share My Records", description: "Send to a doctor or family", color: "#5a88c4" },
  { icon: Download, label: "Export Health Report", description: "Download as PDF", color: C.primary },
  { icon: Phone, label: "Emergency Contacts", description: "Manage contacts", color: "#c75050" },
  { icon: Shield, label: "Privacy & Security", description: "Data protection settings", color: C.sageDark },
];

const settings = [
  { icon: Bell, label: "Reminders & Notifications" },
  { icon: User, label: "My Profile & ID" },
  { icon: Settings, label: "App Settings" },
  { icon: HelpCircle, label: "Help & Support" },
];

const recentActivity = [
  { icon: Activity, color: C.primary, label: "Weight logged — 72.0 kg", time: "Today, 7:30 AM" },
  { icon: Pill, color: "#8b6fa0", label: "Lisinopril taken", time: "Today, 8:05 AM" },
  { icon: Stethoscope, color: C.darkMid, label: "Dr. Chen appointment confirmed", time: "Yesterday" },
  { icon: FlaskConical, color: C.sageDark, label: "Blood test results added", time: "Feb 15" },
];

export function MoreMenu() {
  return (
    <div style={{ background: C.bg, paddingBottom: "24px", fontFamily: '"Open Sans", sans-serif' }}>
      {/* Header */}
      <div style={{ background: `linear-gradient(135deg, ${C.primary} 0%, #b8556a 100%)`, padding: "20px 20px 28px", position: "relative", overflow: "hidden" }}>
        <div style={{ position: "absolute", top: "-20px", right: "-20px", width: "100px", height: "100px", borderRadius: "50px", background: "rgba(255,255,255,0.1)" }} />
        <div style={{ display: "flex", alignItems: "center", gap: "14px" }}>
          <div style={{ width: "56px", height: "56px", borderRadius: "28px", background: C.primaryLight, display: "flex", alignItems: "center", justifyContent: "center", fontSize: "26px", border: "3px solid rgba(255,255,255,0.5)" }}>
            👩
          </div>
          <div>
            <h1 style={{ color: "white", fontSize: "20px", fontWeight: "700", margin: "0 0 2px" }}>Margaret Williams</h1>
            <p style={{ color: "rgba(255,255,255,0.8)", fontSize: "13px", margin: 0 }}>DOB: 12 June 1960 · Age 65</p>
            <p style={{ color: "rgba(255,255,255,0.7)", fontSize: "12px", margin: "2px 0 0" }}>Blood Type: A+ · GP: Dr. Sarah Chen</p>
          </div>
        </div>
        {/* Quick stats row */}
        <div style={{ display: "flex", gap: "8px", marginTop: "16px" }}>
          {[
            { label: "Medications", value: "4 active" },
            { label: "Conditions", value: "4 tracked" },
            { label: "Next Visit", value: "Mar 8" },
          ].map((s) => (
            <div key={s.label} style={{ flex: 1, background: "rgba(255,255,255,0.2)", borderRadius: "12px", padding: "8px 10px", textAlign: "center" }}>
              <p style={{ fontSize: "13px", fontWeight: "700", color: "white", margin: "0 0 2px" }}>{s.value}</p>
              <p style={{ fontSize: "11px", color: "rgba(255,255,255,0.75)", margin: 0 }}>{s.label}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Main Navigation Links */}
      <div style={{ padding: "20px 16px 0" }}>
        <p style={{ fontSize: "12px", fontWeight: "700", color: C.textSecondary, textTransform: "uppercase", letterSpacing: "0.5px", margin: "0 0 10px" }}>Health Records</p>
        <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
          {mainLinks.map(({ path, icon: Icon, label, description, color, bg }) => (
            <Link key={path} to={path} style={{ textDecoration: "none" }}>
              <div style={{ background: C.card, borderRadius: "16px", padding: "14px 16px", display: "flex", alignItems: "center", gap: "12px", boxShadow: "0 2px 10px rgba(84,70,58,0.06)", border: `1px solid ${C.border}` }}>
                <div style={{ width: "44px", height: "44px", borderRadius: "14px", background: bg, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
                  <Icon size={22} color={color} />
                </div>
                <div style={{ flex: 1 }}>
                  <p style={{ fontSize: "15px", fontWeight: "700", color: C.textPrimary, margin: "0 0 2px" }}>{label}</p>
                  <p style={{ fontSize: "12px", color: C.textSecondary, margin: 0 }}>{description}</p>
                </div>
                <ChevronRight size={16} color={C.border} />
              </div>
            </Link>
          ))}
        </div>
      </div>

      {/* Tools */}
      <div style={{ padding: "20px 16px 0" }}>
        <p style={{ fontSize: "12px", fontWeight: "700", color: C.textSecondary, textTransform: "uppercase", letterSpacing: "0.5px", margin: "0 0 10px" }}>Tools</p>
        <div style={{ background: C.card, borderRadius: "16px", overflow: "hidden", boxShadow: "0 2px 10px rgba(84,70,58,0.06)" }}>
          {tools.map(({ icon: Icon, label, description, color }, i) => (
            <div
              key={i}
              style={{
                padding: "14px 16px",
                borderBottom: i < tools.length - 1 ? `1px solid ${C.border}` : "none",
                display: "flex",
                alignItems: "center",
                gap: "12px",
                cursor: "pointer",
              }}
            >
              <div style={{ width: "36px", height: "36px", borderRadius: "10px", background: `${color}18`, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
                <Icon size={18} color={color} />
              </div>
              <div style={{ flex: 1 }}>
                <p style={{ fontSize: "14px", fontWeight: "600", color: C.textPrimary, margin: "0 0 2px" }}>{label}</p>
                <p style={{ fontSize: "12px", color: C.textSecondary, margin: 0 }}>{description}</p>
              </div>
              <ChevronRight size={16} color={C.border} />
            </div>
          ))}
        </div>
      </div>

      {/* Settings */}
      <div style={{ padding: "20px 16px 0" }}>
        <p style={{ fontSize: "12px", fontWeight: "700", color: C.textSecondary, textTransform: "uppercase", letterSpacing: "0.5px", margin: "0 0 10px" }}>Settings & Support</p>
        <div style={{ background: C.card, borderRadius: "16px", overflow: "hidden", boxShadow: "0 2px 10px rgba(84,70,58,0.06)" }}>
          {settings.map(({ icon: Icon, label }, i) => (
            <div
              key={i}
              style={{
                padding: "14px 16px",
                borderBottom: i < settings.length - 1 ? `1px solid ${C.border}` : "none",
                display: "flex",
                alignItems: "center",
                gap: "12px",
                cursor: "pointer",
              }}
            >
              <div style={{ width: "36px", height: "36px", borderRadius: "10px", background: C.bg, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
                <Icon size={18} color={C.textSecondary} />
              </div>
              <p style={{ fontSize: "14px", fontWeight: "500", color: C.textPrimary, margin: 0, flex: 1 }}>{label}</p>
              <ChevronRight size={16} color={C.border} />
            </div>
          ))}
        </div>
      </div>

      {/* Recent Activity */}
      <div style={{ padding: "20px 16px 0" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "10px" }}>
          <p style={{ fontSize: "12px", fontWeight: "700", color: C.textSecondary, textTransform: "uppercase", letterSpacing: "0.5px", margin: 0 }}>Recent Activity</p>
          <span style={{ fontSize: "13px", color: C.primary, fontWeight: "600" }}>View all</span>
        </div>
        <div style={{ background: C.card, borderRadius: "16px", overflow: "hidden", boxShadow: "0 2px 10px rgba(84,70,58,0.06)" }}>
          {recentActivity.map(({ icon: Icon, color, label, time }, i) => (
            <div
              key={i}
              style={{
                display: "flex",
                alignItems: "center",
                gap: "12px",
                padding: "14px 16px",
                borderBottom: i < recentActivity.length - 1 ? `1px solid ${C.border}` : "none",
              }}
            >
              <div style={{ width: "36px", height: "36px", borderRadius: "12px", background: `${color}18`, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
                <Icon size={18} color={color} />
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <p style={{ fontSize: "14px", color: C.textPrimary, margin: "0 0 2px", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{label}</p>
                <p style={{ fontSize: "12px", color: C.textSecondary, margin: 0 }}>{time}</p>
              </div>
              <ChevronRight size={16} color={C.border} />
            </div>
          ))}
        </div>
      </div>

      {/* Version */}
      <div style={{ textAlign: "center", padding: "24px 0 0" }}>
        <p style={{ fontSize: "12px", color: C.textSecondary, margin: 0 }}>MyHealth Companion · Version 1.0.0</p>
        <p style={{ fontSize: "11px", color: C.border, margin: "4px 0 0" }}>Your health data is private and encrypted</p>
      </div>
    </div>
  );
}