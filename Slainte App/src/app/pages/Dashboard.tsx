import { useState, useEffect } from "react";
import { Link } from "react-router";
import {
  Activity, FlaskConical, Stethoscope, Pill, FileText,
  ChevronRight, Bell, Clock,
  AlertCircle, CheckCircle2, MapPin, X
} from "lucide-react";
import { C } from "../constants/colors";

const quickActions = [
  { label: "Log Vitals", icon: Activity, color: C.primary, bg: C.pink100, path: "/vitals" },
  { label: "Test Results", icon: FlaskConical, color: C.sageDark, bg: C.sage50, path: "/tests" },
  { label: "Doctor Visit", icon: Stethoscope, color: C.darkMid, bg: "#f3ede8", path: "/visits" },
  { label: "Prescriptions", icon: Pill, color: "#8b6fa0", bg: "#f3eef8", path: "/prescriptions" },
  { label: "My History", icon: FileText, color: "#c47c2f", bg: "#fdf3e7", path: "/history" },
];

const medications = [
  { name: "Lisinopril 10mg", time: "8:00 AM", taken: true },
  { name: "Atorvastatin 20mg", time: "9:00 PM", taken: false },
  { name: "Metformin 500mg", time: "1:00 PM", taken: true },
];

/** iOS-style push notification banner */
function IOSNotification({ onDismiss }: { onDismiss: () => void }) {
  return (
    <div
      style={{
        position: "fixed",
        top: "12px",
        left: "50%",
        transform: "translateX(-50%)",
        width: "calc(100% - 32px)",
        maxWidth: "390px",
        zIndex: 9999,
        animation: "slideDownNotif 0.4s cubic-bezier(0.34,1.2,0.64,1) forwards",
      }}
    >
      <style>{`
        @keyframes slideDownNotif {
          from { opacity: 0; transform: translateX(-50%) translateY(-60px); }
          to   { opacity: 1; transform: translateX(-50%) translateY(0); }
        }
      `}</style>
      <div
        style={{
          background: "rgba(255,255,255,0.94)",
          backdropFilter: "blur(20px)",
          WebkitBackdropFilter: "blur(20px)",
          borderRadius: "16px",
          padding: "12px 14px",
          boxShadow: "0 8px 32px rgba(0,0,0,0.18), 0 2px 8px rgba(0,0,0,0.08)",
          display: "flex",
          alignItems: "flex-start",
          gap: "10px",
        }}
      >
        {/* App icon */}
        <div
          style={{
            width: "36px",
            height: "36px",
            borderRadius: "9px",
            background: `linear-gradient(135deg, ${C.primary} 0%, #b8556a 100%)`,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            flexShrink: 0,
          }}
        >
          <span style={{ fontSize: "18px" }}>❤️</span>
        </div>

        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "2px" }}>
            <span style={{ fontSize: "12px", fontWeight: "700", color: "#1c1c1e", textTransform: "uppercase", letterSpacing: "0.3px" }}>
              MyHealth Companion
            </span>
            <span style={{ fontSize: "11px", color: "#8e8e93" }}>now</span>
          </div>
          <p style={{ fontSize: "13px", fontWeight: "600", color: "#1c1c1e", margin: "0 0 1px" }}>
            💊 Prescription Refill Reminder
          </p>
          <p style={{ fontSize: "13px", color: "#3c3c43cc", margin: 0, lineHeight: "1.4" }}>
            Your Lisinopril refill is due in 10 days. Contact Dr. Chen to request a renewal.
          </p>
        </div>

        <button
          onClick={onDismiss}
          style={{
            background: "none",
            border: "none",
            padding: "2px",
            cursor: "pointer",
            flexShrink: 0,
            opacity: 0.4,
          }}
        >
          <X size={16} color="#1c1c1e" />
        </button>
      </div>
    </div>
  );
}

export function Dashboard() {
  const [showNotification, setShowNotification] = useState(false);

  useEffect(() => {
    // Simulate iOS notification arriving after 1.5s
    const timer = setTimeout(() => setShowNotification(true), 1500);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    // Auto-dismiss after 6 seconds
    if (!showNotification) return;
    const timer = setTimeout(() => setShowNotification(false), 6000);
    return () => clearTimeout(timer);
  }, [showNotification]);

  const today = new Date();
  const dateStr = today.toLocaleDateString("en-GB", { weekday: "long", day: "numeric", month: "long", year: "numeric" });

  const takenCount = medications.filter((m) => m.taken).length;
  const totalCount = medications.length;

  return (
    <div style={{ background: C.bg, paddingBottom: "24px", fontFamily: '"Open Sans", sans-serif' }}>

      {/* iOS Push Notification */}
      {showNotification && (
        <IOSNotification onDismiss={() => setShowNotification(false)} />
      )}

      {/* Header */}
      <div
        style={{
          background: `linear-gradient(135deg, ${C.primary} 0%, #b8556a 100%)`,
          padding: "20px 20px 28px",
          position: "relative",
          overflow: "hidden",
        }}
      >
        <div style={{ position: "absolute", top: "-30px", right: "-30px", width: "120px", height: "120px", borderRadius: "60px", background: "rgba(255,255,255,0.1)" }} />
        <div style={{ position: "absolute", top: "10px", right: "30px", width: "60px", height: "60px", borderRadius: "30px", background: "rgba(255,255,255,0.08)" }} />

        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: "12px" }}>
          <div style={{ display: "flex", alignItems: "center", gap: "12px" }}>
            <div
              style={{
                width: "46px", height: "46px", borderRadius: "23px",
                background: C.primaryLight,
                display: "flex", alignItems: "center", justifyContent: "center",
                border: "2px solid rgba(255,255,255,0.5)",
                fontSize: "18px",
              }}
            >
              👩
            </div>
            <div>
              <p style={{ color: "rgba(255,255,255,0.85)", fontSize: "13px", margin: 0 }}>Good morning,</p>
              <h1 style={{ color: "white", fontSize: "20px", fontWeight: "700", margin: 0 }}>Margaret</h1>
            </div>
          </div>
          <button
            onClick={() => setShowNotification(true)}
            style={{ background: "rgba(255,255,255,0.2)", border: "none", borderRadius: "12px", width: "40px", height: "40px", display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer", position: "relative" }}
          >
            <Bell size={20} color="white" />
            {/* Red badge dot */}
            <div style={{ position: "absolute", top: "8px", right: "8px", width: "8px", height: "8px", borderRadius: "4px", background: "#ff3b30", border: "1.5px solid rgba(255,255,255,0.8)" }} />
          </button>
        </div>
        <p style={{ color: "rgba(255,255,255,0.75)", fontSize: "13px", margin: 0 }}>{dateStr}</p>
      </div>

      {/* Today's Overview */}
      <div style={{ margin: "-16px 16px 0", position: "relative", zIndex: 10 }}>
        <div
          style={{
            background: C.card,
            borderRadius: "20px",
            padding: "16px",
            boxShadow: "0 4px 20px rgba(84,70,58,0.12)",
          }}
        >
          <p style={{ color: C.textSecondary, fontSize: "12px", fontWeight: "600", textTransform: "uppercase", letterSpacing: "0.5px", margin: "0 0 12px" }}>Today's Overview</p>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px" }}>
            {/* Medications */}
            <div style={{ background: C.pink50, borderRadius: "14px", padding: "12px" }}>
              <div style={{ display: "flex", alignItems: "center", gap: "6px", marginBottom: "4px" }}>
                <Pill size={16} color={C.primary} />
                <span style={{ fontSize: "12px", color: C.textSecondary }}>Medications</span>
              </div>
              <p style={{ fontSize: "22px", fontWeight: "700", color: C.textPrimary, margin: "0 0 2px" }}>
                {takenCount}<span style={{ fontSize: "14px", color: C.textSecondary, fontWeight: "400" }}>/{totalCount}</span>
              </p>
              <p style={{ fontSize: "11px", color: C.primary, margin: 0 }}>taken today</p>
            </div>

            {/* Today's Appointment */}
            <div style={{ background: C.sage50, borderRadius: "14px", padding: "12px" }}>
              <div style={{ display: "flex", alignItems: "center", gap: "6px", marginBottom: "6px" }}>
                <Stethoscope size={16} color={C.sageDark} />
                <span style={{ fontSize: "12px", color: C.textSecondary }}>Appointment</span>
              </div>
              <p style={{ fontSize: "15px", fontWeight: "700", color: C.textPrimary, margin: "0 0 1px", lineHeight: "1.2" }}>Dr. Chen</p>
              <p style={{ fontSize: "11px", color: C.sageDark, margin: "0 0 4px", fontWeight: "600" }}>Today · 10:30 AM</p>
              <div style={{ display: "flex", alignItems: "flex-start", gap: "4px" }}>
                <MapPin size={11} color={C.textSecondary} style={{ flexShrink: 0, marginTop: "1px" }} />
                <p style={{ fontSize: "11px", color: C.textSecondary, margin: 0, lineHeight: "1.3" }}>
                  City Medical Centre<br />45 Park Lane, Level 2
                </p>
              </div>
            </div>
          </div>

          {/* Medication progress bar */}
          <div style={{ marginTop: "12px" }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "8px" }}>
              <span style={{ fontSize: "13px", color: C.textSecondary }}>Medication progress</span>
              <span style={{ fontSize: "12px", color: C.primary, fontWeight: "600" }}>{Math.round((takenCount / totalCount) * 100)}%</span>
            </div>
            <div style={{ height: "6px", background: C.border, borderRadius: "3px", overflow: "hidden" }}>
              <div style={{ height: "100%", width: `${(takenCount / totalCount) * 100}%`, background: C.primary, borderRadius: "3px", transition: "width 0.5s" }} />
            </div>
          </div>
        </div>
      </div>

      {/* Today's Medications */}
      <div style={{ padding: "20px 16px 0" }}>
        <div style={{ background: `${C.primaryLight}40`, borderRadius: "16px", padding: "14px 16px", border: `1px solid ${C.primaryLight}` }}>
          <div style={{ display: "flex", alignItems: "center", gap: "8px", marginBottom: "10px" }}>
            <Clock size={16} color={C.primary} />
            <span style={{ fontSize: "14px", fontWeight: "600", color: C.primary }}>Today's Medications</span>
          </div>
          {medications.map((med, i) => (
            <div key={i} style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "8px 0", borderBottom: i < medications.length - 1 ? `1px solid ${C.primaryLight}` : "none" }}>
              <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
                {med.taken
                  ? <CheckCircle2 size={18} color="#5dab6f" />
                  : <div style={{ width: "18px", height: "18px", borderRadius: "9px", border: `2px solid ${C.border}` }} />
                }
                <div>
                  <p style={{ margin: 0, fontSize: "14px", color: C.textPrimary, textDecoration: med.taken ? "line-through" : "none", opacity: med.taken ? 0.6 : 1 }}>{med.name}</p>
                  <p style={{ margin: 0, fontSize: "12px", color: C.textSecondary }}>{med.time}</p>
                </div>
              </div>
              {!med.taken && (
                <button style={{ background: C.primary, color: "white", border: "none", borderRadius: "10px", padding: "5px 12px", fontSize: "12px", cursor: "pointer", fontFamily: '"Open Sans", sans-serif', fontWeight: "600" }}>
                  Take
                </button>
              )}
            </div>
          ))}
        </div>
      </div>

      {/* Quick Actions */}
      <div style={{ padding: "20px 16px 0" }}>
        <p style={{ fontSize: "16px", fontWeight: "700", color: C.textPrimary, margin: "0 0 12px" }}>Quick Actions</p>
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: "10px" }}>
          {quickActions.map(({ label, icon: Icon, color, bg, path }) => (
            <Link key={path} to={path} style={{ textDecoration: "none" }}>
              <div
                style={{
                  background: bg,
                  borderRadius: "16px",
                  padding: "14px 10px",
                  display: "flex",
                  flexDirection: "column",
                  alignItems: "center",
                  gap: "8px",
                  border: `1px solid ${color}22`,
                  transition: "transform 0.1s",
                }}
              >
                <div style={{ width: "40px", height: "40px", borderRadius: "12px", background: `${color}22`, display: "flex", alignItems: "center", justifyContent: "center" }}>
                  <Icon size={20} color={color} strokeWidth={1.8} />
                </div>
                <span style={{ fontSize: "12px", fontWeight: "600", color: C.textPrimary, textAlign: "center", lineHeight: "1.3" }}>{label}</span>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </div>
  );
}
