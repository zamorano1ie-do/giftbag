import { Outlet, NavLink, useOutletContext } from "react-router";
import { useState } from "react";
import { Home, Activity, FlaskConical, Stethoscope, MoreHorizontal, Mic } from "lucide-react";
import { C } from "../constants/colors";
import { VoiceInputModal } from "./VoiceInputModal";

type LayoutContext = {
  openVoice: () => void;
};

export function useLayoutContext() {
  return useOutletContext<LayoutContext>();
}

const navItems = [
  { path: "/", icon: Home, label: "Home" },
  { path: "/vitals", icon: Activity, label: "Vitals" },
  { path: "/tests", icon: FlaskConical, label: "Tests" },
  { path: "/visits", icon: Stethoscope, label: "Visits" },
  { path: "/more", icon: MoreHorizontal, label: "More" },
];

export function Layout() {
  const [voiceOpen, setVoiceOpen] = useState(false);

  return (
    <div
      style={{
        minHeight: "100vh",
        background: "linear-gradient(150deg, #e8ddd6 0%, #d8d0c8 50%, #cdd8cb 100%)",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        padding: "20px",
        fontFamily: '"Open Sans", sans-serif',
      }}
    >
      <div
        style={{
          width: "min(390px, 100%)",
          height: "min(844px, 100dvh)",
          background: C.bg,
          borderRadius: "clamp(0px, 5vw, 55px)",
          overflow: "hidden",
          position: "relative",
          boxShadow: "0 40px 80px rgba(0,0,0,0.35), 0 0 0 11px #1c1c1e, 0 0 0 13px #3a3a3c",
          display: "flex",
          flexDirection: "column",
        }}
      >
        {/* iOS Status Bar */}
        <div
          style={{
            background: "#1c1c1e",
            padding: "14px 24px 10px",
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            flexShrink: 0,
          }}
        >
          <span style={{ color: "white", fontSize: "15px", fontWeight: "600", fontFamily: '"Open Sans", sans-serif' }}>
            9:41
          </span>
          {/* Dynamic Island */}
          <div
            style={{
              background: "#000",
              borderRadius: "20px",
              padding: "6px 20px",
              border: "1px solid #2a2a2a",
            }}
          >
            <div style={{ width: "60px", height: "5px", background: "#2a2a2a", borderRadius: "3px" }} />
          </div>
          {/* Status icons */}
          <div style={{ display: "flex", gap: "6px", alignItems: "center" }}>
            <div style={{ display: "flex", gap: "2px", alignItems: "flex-end" }}>
              {[4, 6, 8, 10].map((h, i) => (
                <div
                  key={i}
                  style={{ width: "3px", height: `${h}px`, background: i < 3 ? "white" : "#555", borderRadius: "1px" }}
                />
              ))}
            </div>
            <svg width="15" height="11" viewBox="0 0 15 11" fill="white" opacity="0.9">
              <path d="M7.5 2.5C9.5 2.5 11.3 3.3 12.6 4.7L14 3.2C12.3 1.4 9.9 0.3 7.5 0.3S2.7 1.4 1 3.2L2.4 4.7C3.7 3.3 5.5 2.5 7.5 2.5zM7.5 5C8.7 5 9.8 5.5 10.6 6.3L12 4.8C10.8 3.7 9.2 3 7.5 3S4.2 3.7 3 4.8L4.4 6.3C5.2 5.5 6.3 5 7.5 5zM7.5 7.5C8.2 7.5 8.8 7.8 9.2 8.3L7.5 10.3L5.8 8.3C6.2 7.8 6.8 7.5 7.5 7.5z" />
            </svg>
            <div style={{ width: "24px", height: "12px", border: "1.5px solid rgba(255,255,255,0.7)", borderRadius: "3px", position: "relative", padding: "1.5px" }}>
              <div style={{ width: "80%", height: "100%", background: "#4ade80", borderRadius: "1px" }} />
              <div style={{ width: "3px", height: "5px", background: "rgba(255,255,255,0.5)", position: "absolute", right: "-5px", top: "50%", transform: "translateY(-50%)", borderRadius: "0 2px 2px 0" }} />
            </div>
          </div>
        </div>

        {/* Content area */}
        <div style={{ flex: 1, overflowY: "auto", overflowX: "hidden", position: "relative" }}>
          <Outlet context={{ openVoice: () => setVoiceOpen(true) } satisfies LayoutContext} />
        </div>

        {/* Floating Voice Button */}
        <button
          onClick={() => setVoiceOpen(true)}
          style={{
            position: "absolute",
            bottom: "76px",
            right: "20px",
            width: "54px",
            height: "54px",
            borderRadius: "27px",
            background: C.primary,
            border: "none",
            cursor: "pointer",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            boxShadow: `0 4px 16px ${C.primary}66`,
            zIndex: 50,
          }}
        >
          <Mic size={22} color="white" />
        </button>

        {/* Bottom Navigation */}
        <div
          style={{
            background: "rgba(255,255,255,0.97)",
            borderTop: `1px solid ${C.border}`,
            paddingTop: "8px",
            flexShrink: 0,
            backdropFilter: "blur(10px)",
          }}
        >
          <div style={{ display: "flex", justifyContent: "space-around" }}>
            {navItems.map(({ path, icon: Icon, label }) => (
              <NavLink
                key={path}
                to={path}
                end={path === "/"}
                style={{ textDecoration: "none", display: "flex", flexDirection: "column", alignItems: "center", gap: "3px", padding: "4px 12px", minWidth: "58px" }}
              >
                {({ isActive }) => (
                  <>
                    <div
                      style={{
                        width: "40px",
                        height: "30px",
                        borderRadius: "12px",
                        background: isActive ? `${C.primary}18` : "transparent",
                        display: "flex",
                        alignItems: "center",
                        justifyContent: "center",
                        transition: "background 0.2s",
                      }}
                    >
                      <Icon size={22} color={isActive ? C.primary : "#B8ABA5"} strokeWidth={isActive ? 2.5 : 1.8} />
                    </div>
                    <span
                      style={{
                        fontSize: "10px",
                        color: isActive ? C.primary : "#B8ABA5",
                        fontWeight: isActive ? "600" : "400",
                        fontFamily: '"Open Sans", sans-serif',
                      }}
                    >
                      {label}
                    </span>
                  </>
                )}
              </NavLink>
            ))}
          </div>
          {/* Home indicator */}
          <div style={{ display: "flex", justifyContent: "center", padding: "8px 0 4px" }}>
            <div style={{ width: "120px", height: "4px", background: "#1c1c1e", borderRadius: "2px" }} />
          </div>
        </div>

        {/* Voice Modal overlay (inside phone frame) */}
        {voiceOpen && (
          <div style={{ position: "absolute", inset: 0, zIndex: 100 }}>
            <VoiceInputModal onClose={() => setVoiceOpen(false)} />
          </div>
        )}
      </div>
    </div>
  );
}
