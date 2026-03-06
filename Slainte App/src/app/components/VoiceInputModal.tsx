import { useState, useEffect, useRef } from "react";
import { Mic, MicOff, Camera, X, Send } from "lucide-react";
import { C } from "../constants/colors";

interface VoiceInputModalProps {
  onClose: () => void;
  context?: string;
  onSubmit?: (text: string) => void;
}

const mockResponses: Record<string, string[]> = {
  vitals: [
    "Weight 72 kg, blood pressure 128 over 82, heart rate 74",
    "My weight today is 71.5 kilograms",
    "Blood pressure reading: 130 over 85",
  ],
  prescription: [
    "Lisinopril 10mg, once daily in the morning",
    "Started taking Metformin 500mg twice a day",
  ],
  visit: [
    "Saw Dr. Chen today for annual checkup, blood pressure still high",
    "GP visit on March 8th, discussed cholesterol results",
  ],
  default: [
    "I took my morning medications",
    "Feeling a bit tired today, headache since morning",
    "Blood glucose reading this morning was 5.8",
  ],
};

export function VoiceInputModal({ onClose, context = "default", onSubmit }: VoiceInputModalProps) {
  const [phase, setPhase] = useState<"idle" | "listening" | "processing" | "done">("idle");
  const [text, setText] = useState("");
  const [pulseScale, setPulseScale] = useState(1);
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current);
    };
  }, []);

  const startListening = () => {
    setPhase("listening");
    setText("");
    intervalRef.current = setInterval(() => {
      setPulseScale((s) => (s === 1 ? 1.3 : 1));
    }, 600);

    setTimeout(() => {
      if (intervalRef.current) clearInterval(intervalRef.current);
      setPulseScale(1);
      setPhase("processing");
      setTimeout(() => {
        const responses = mockResponses[context] || mockResponses.default;
        const randomText = responses[Math.floor(Math.random() * responses.length)];
        setText(randomText);
        setPhase("done");
      }, 800);
    }, 2500);
  };

  const stopListening = () => {
    if (intervalRef.current) clearInterval(intervalRef.current);
    setPulseScale(1);
    setPhase("idle");
  };

  const handleSubmit = () => {
    if (text.trim() && onSubmit) onSubmit(text.trim());
    onClose();
  };

  return (
    <div
      style={{
        position: "absolute",
        inset: 0,
        zIndex: 200,
        display: "flex",
        flexDirection: "column",
        justifyContent: "flex-end",
        fontFamily: '"Open Sans", sans-serif',
      }}
    >
      {/* Backdrop */}
      <div
        onClick={onClose}
        style={{
          position: "absolute",
          inset: 0,
          background: "rgba(84,70,58,0.45)",
          backdropFilter: "blur(3px)",
        }}
      />

      {/* Bottom Sheet */}
      <div
        style={{
          position: "relative",
          zIndex: 1,
          background: C.card,
          borderRadius: "28px 28px 0 0",
          padding: "12px 24px 32px",
          boxShadow: "0 -4px 30px rgba(0,0,0,0.15)",
        }}
      >
        {/* Handle */}
        <div style={{ display: "flex", justifyContent: "center", marginBottom: "16px" }}>
          <div style={{ width: "40px", height: "4px", background: C.border, borderRadius: "2px" }} />
        </div>

        {/* Close button */}
        <button
          onClick={onClose}
          style={{ position: "absolute", top: "16px", right: "20px", background: "none", border: "none", cursor: "pointer", padding: "4px" }}
        >
          <X size={22} color={C.darkMid} />
        </button>

        <p style={{ color: C.textSecondary, fontSize: "13px", textAlign: "center", marginBottom: "24px" }}>
          Tap the mic to speak, or type your health note
        </p>

        {/* Mic button area */}
        <div style={{ display: "flex", flexDirection: "column", alignItems: "center", marginBottom: "24px" }}>
          <div style={{ position: "relative", marginBottom: "12px" }}>
            {phase === "listening" && (
              <>
                <div style={{ position: "absolute", inset: "-16px", borderRadius: "50%", background: `${C.primary}22`, transform: `scale(${pulseScale})`, transition: "transform 0.6s ease" }} />
                <div style={{ position: "absolute", inset: "-8px", borderRadius: "50%", background: `${C.primary}33`, transform: `scale(${pulseScale})`, transition: "transform 0.5s ease" }} />
              </>
            )}
            <button
              onClick={phase === "listening" ? stopListening : startListening}
              disabled={phase === "processing"}
              style={{
                width: "80px",
                height: "80px",
                borderRadius: "40px",
                background: phase === "listening" ? C.primary : phase === "processing" ? C.primaryLight : C.primary,
                border: "none",
                cursor: phase === "processing" ? "wait" : "pointer",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                boxShadow: `0 6px 24px ${C.primary}55`,
                transition: "all 0.3s ease",
                position: "relative",
              }}
            >
              {phase === "listening" ? (
                <MicOff size={32} color="white" />
              ) : (
                <Mic size={32} color="white" />
              )}
            </button>
          </div>

          <p style={{ fontSize: "14px", color: phase === "listening" ? C.primary : phase === "processing" ? C.darkMid : C.textSecondary, fontWeight: phase === "listening" ? "600" : "400" }}>
            {phase === "idle" ? "Tap to speak" : phase === "listening" ? "Listening..." : phase === "processing" ? "Processing..." : "Got it!"}
          </p>
        </div>

        {/* Text input */}
        <div style={{ position: "relative", marginBottom: "16px" }}>
          <textarea
            value={text}
            onChange={(e) => setText(e.target.value)}
            placeholder="Or type your note here..."
            rows={3}
            style={{
              width: "100%",
              padding: "14px 50px 14px 16px",
              border: `1.5px solid ${text ? C.primary : C.border}`,
              borderRadius: "16px",
              fontSize: "15px",
              fontFamily: '"Open Sans", sans-serif',
              color: C.textPrimary,
              background: C.bg,
              resize: "none",
              outline: "none",
              boxSizing: "border-box",
              lineHeight: "1.5",
            }}
          />
        </div>

        {/* Action buttons */}
        <div style={{ display: "flex", gap: "12px" }}>
          <button
            style={{
              flexShrink: 0,
              width: "52px",
              height: "52px",
              borderRadius: "14px",
              background: C.sage50,
              border: `1.5px solid ${C.sage}55`,
              cursor: "pointer",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            <Camera size={22} color={C.sage} />
          </button>

          <button
            onClick={handleSubmit}
            disabled={!text.trim()}
            style={{
              flex: 1,
              height: "52px",
              borderRadius: "14px",
              background: text.trim() ? C.primary : C.border,
              border: "none",
              cursor: text.trim() ? "pointer" : "default",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              gap: "8px",
              transition: "background 0.2s",
            }}
          >
            <Send size={20} color="white" />
            <span style={{ color: "white", fontWeight: "600", fontSize: "15px" }}>Save Note</span>
          </button>
        </div>
      </div>
    </div>
  );
}
