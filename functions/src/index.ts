import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();

export const onMatchEnded = functions.firestore
  .document("matches/{matchId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    if (before?.status !== "ended" && after?.status === "ended") {
      const settingsDoc = await db.collection("settings").doc("global").get();
      const settings = settingsDoc.data();
      if (settings?.notifications_matchEnd !== true) {
        return null;
      }
      const devicesSnap = await db.collection("devices").get();
      const tokens: string[] = [];
      devicesSnap.docs.forEach((d) => {
        const token = d.data()?.token;
        if (token) tokens.push(token);
      });
      if (tokens.length === 0) return null;
      const winnerId = after.winnerId as string | undefined;
      const sessionId = after.sessionId as string | undefined;
      let sessionTitle = "Session";
      if (sessionId) {
        const sessionDoc = await db.collection("sessions").doc(sessionId).get();
        sessionTitle = sessionDoc.data()?.title ?? sessionTitle;
      }
      let winnerName = "Winner";
      if (winnerId) {
        const matchType = after.matchType as string;
        if (matchType === "2v2") {
          const teamDoc = await db.collection("teams").doc(winnerId).get();
          winnerName = teamDoc.data()?.name ?? winnerId;
        } else {
          const playerDoc = await db.collection("players").doc(winnerId).get();
          winnerName = playerDoc.data()?.name ?? winnerId;
        }
      }
      try {
        await admin.messaging().sendEachForMulticast({
          tokens,
          notification: {
            title: "Match ended!",
            body: `${winnerName} won • ${sessionTitle}`,
          },
          data: {
            sessionId: sessionId || "",
            matchId: context.params.matchId,
          },
        });
      } catch (e) {
        functions.logger.error("FCM send failed", e);
      }
    }
    return null;
  });
