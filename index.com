<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#21040b">
<title>A Little Surprise for You 🍒</title>
<style>
  :root {
    --wine: #4a0718;
    --cherry: #8f1234;
    --red: #c72b50;
    --cream: #fff0ed;
    --pink: #f6b8c6;
    --ink: #160309;
  }
  * { box-sizing: border-box; }
  html { scroll-behavior: smooth; }
  body {
    margin: 0; min-height: 100vh; color: var(--cream);
    font-family: Georgia, "Times New Roman", serif;
    background:
      radial-gradient(ellipse at 50% 20%, rgba(128, 10, 42, .35), transparent 48%),
      linear-gradient(145deg, #080205, #21040b 52%, #090205);
    overflow-x: hidden;
  }
  button, input { font: inherit; }
  button {
    border: 1px solid rgba(255, 210, 219, .55); cursor: pointer;
    color: #fff5f5; background: linear-gradient(135deg, #a51d42, #5c0a21);
    padding: 12px 25px; border-radius: 999px; letter-spacing: .04em;
    box-shadow: 0 8px 24px rgba(0,0,0,.25), 0 0 18px rgba(190,35,75,.12);
    transition: transform .22s ease, filter .22s ease, box-shadow .22s ease;
  }
  button:hover { transform: translateY(-2px); filter: brightness(1.15); box-shadow: 0 10px 28px rgba(0,0,0,.3), 0 0 22px rgba(226,53,94,.25); }
  button:active { transform: scale(.97); }
  .secondary { background: rgba(24,3,10,.7); }
  .screen { display: none; min-height: 100svh; padding: 30px 18px; position: relative; isolation: isolate; }
  .screen.active { display: flex; align-items: center; justify-content: center; animation: screenIn .7s ease both; }
  @keyframes screenIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }
  .panel { width: min(100%, 650px); text-align: center; padding: clamp(24px, 5vw, 46px); border: 1px solid rgba(255,185,201,.22); border-radius: 25px; background: rgba(18,2,8,.65); box-shadow: 0 25px 80px rgba(0,0,0,.32), inset 0 0 40px rgba(130,12,44,.08); backdrop-filter: blur(7px); }
  h1, h2, p { margin-top: 0; }
  h1 { font-size: clamp(2rem, 7vw, 3.5rem); line-height: 1.12; font-weight: normal; }
  h2 { font-size: clamp(1.6rem, 5vw, 2.4rem); font-weight: normal; }
  p { font-size: clamp(1rem, 2.8vw, 1.14rem); line-height: 1.8; color: #f8dfe5; }
  .eyebrow { color: var(--pink); letter-spacing: .22em; text-transform: uppercase; font:  .72rem/1.6 Arial, sans-serif; }
  .glow { color: #ffd1dc; text-shadow: 0 0 16px rgba(245,95,135,.5); }
  .tiny { font-size: .92rem; color: #dca8b5; }
  .actions { display: flex; justify-content: center; align-items: center; gap: 12px; flex-wrap: wrap; margin-top: 25px; }
  .message { min-height: 28px; margin: 18px 0 0; color: #ffb8ca; font-style: italic; }
  .password-wrap { position: relative; max-width: 340px; margin: 25px auto 0; }
  .password-wrap .lock { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); }
  input[type="password"] { width: 100%; padding: 15px 16px 15px 45px; border-radius: 14px; border: 1px solid rgba(255,185,201,.38); background: rgba(0,0,0,.35); color: white; outline: none; }
  input:focus { border-color: #f38ca8; box-shadow: 0 0 0 3px rgba(243,140,168,.12); }
  .black-heart { position: fixed; z-index: -1; top: -40px; color: #050205; text-shadow: 0 0 8px rgba(150,20,50,.22); animation: fall linear forwards; pointer-events: none; }
  @keyframes fall { to { transform: translateY(115vh) rotate(360deg); opacity: .1; } }
  /* Envelope */
  .envelope-scene { margin: 35px auto 20px; width: min(300px, 80vw); height: 190px; position: relative; perspective: 900px; filter: drop-shadow(0 16px 24px rgba(0,0,0,.3)); }
  .envelope { position: absolute; inset: 25px 0 0; background: #6e0d29; border: 1px solid #d56a86; border-radius: 4px 4px 12px 12px; overflow: visible; }
  .envelope::before { content:""; position:absolute; inset:0; background: linear-gradient(145deg, transparent 49%, rgba(30,0,8,.35) 50%), linear-gradient(215deg, transparent 49%, rgba(255,150,175,.15) 50%); }
  .flap { position: absolute; top: 0; left: 0; width: 100%; height: 100px; background: #8f1637; clip-path: polygon(0 0, 100% 0, 50% 100%); transform-origin: top; z-index: 5; transition: transform .9s ease; border-top: 1px solid #f0a1b5; }
  .seal { position:absolute; z-index:6; left:50%; top:75px; transform:translateX(-50%); font-size: 30px; transition: opacity .3s ease; }
  .letter-slip { position:absolute; left:8%; width:84%; height:125px; bottom:12px; background:#fff0e9; color:#65102a; padding:20px 8px; text-align:center; font-size:1rem; transform:translateY(0); transition:transform 1s ease .35s; z-index:2; border-radius:3px; }
  .envelope-scene.opened .flap { transform: rotateX(180deg); z-index:1; }
  .envelope-scene.opened .seal { opacity:0; }
  .envelope-scene.opened .letter-slip { transform:translateY(-95px); }
  /* Letter page and dramatic rose vines */
  #letterScreen { overflow: hidden; }
  .rose-vine { position:absolute; top:0; bottom:0; width: min(19vw, 210px); opacity:.85; z-index:-1; pointer-events:none; }
  .rose-vine.left { left:0; }
  .rose-vine.right { right:0; transform:scaleX(-1); }
  .rose-vine svg { width:100%; height:100%; }
  .letter-paper { width:min(760px, 100%); max-height:86svh; overflow:auto; text-align:left; padding:clamp(22px, 5vw, 48px); color:#4d1020; background:linear-gradient(135deg,#fff4ed,#f6d8d5); border:1px solid #d99aa7; border-radius:4px; box-shadow:0 25px 90px rgba(0,0,0,.55), 0 0 38px rgba(180,23,61,.18); line-height:1.85; animation: letterReveal 1.2s ease both; }
  @keyframes letterReveal { from { opacity:0; transform:translateY(35px) scale(.97); } to { opacity:1; transform:translateY(0) scale(1); } }
  .letter-paper p { color:#4d1020; font-size:1rem; line-height:1.85; margin:0 0 17px; }
  .letter-paper .letter-title { font-size:1.35rem; font-weight:bold; }
  .letter-paper .signature { text-align:right; margin-top:25px; }
  .letter-paper strong { color:#8a1233; }
  .letter-actions { text-align:center; margin:22px 0 0; }
  /* Memories */
  #memoriesScreen { align-items:flex-start; }
  .memories-wrap { width:min(100%, 1050px); text-align:center; }
  .polaroids { display:grid; grid-template-columns:repeat(auto-fit, minmax(min(100%, 220px), 1fr)); gap:25px; margin:30px auto; align-items:start; }
  .polaroid { background:#fff2ed; color:#561024; padding:12px 12px 17px; border-radius:3px; box-shadow:0 16px 35px rgba(0,0,0,.35); transform:rotate(var(--tilt, -2deg)); transition:transform .25s ease; cursor:pointer; }
  .polaroid:nth-child(even) { --tilt: 2deg; }
  .polaroid:hover { transform:rotate(0deg) translateY(-5px); }
  .polaroid img { width:100%; height:240px; object-fit:cover; display:block; background:linear-gradient(145deg,#3b0718,#b53a5b); }
  .polaroid .placeholder { display:none; height:240px; align-items:center; justify-content:center; flex-direction:column; gap:8px; background:linear-gradient(145deg,#3b0718,#b53a5b); color:#ffe1e7; }
  .polaroid .caption { font-size:1rem; padding:13px 4px 0; color:#561024; }
  .next-note { margin:34px auto 20px; line-height:1.9; }
  /* Final page */
  .final-heart { font-size:clamp(2rem, 8vw, 4rem); animation: heartbeat 1.3s ease-in-out infinite; display:inline-block; }
  @keyframes heartbeat { 0%,100% { transform:scale(1); } 15% { transform:scale(1.16); } 30% { transform:scale(1); } 45% { transform:scale(1.1); } }
  .kiss { position:fixed; z-index:10; pointer-events:none; animation:kissFly 2.3s ease-out forwards; font-size:30px; }
  @keyframes kissFly { 0% { opacity:0; transform:translate(0,0) scale(.5) rotate(-15deg); } 15% {opacity:1;} 100% { opacity:0; transform:translate(var(--dx),-75vh) scale(1.5) rotate(20deg); } }
  .kiss-mark { display:inline-block; color:#d83b61; font-size:1.7em; margin:0 4px; transform:rotate(-12deg); text-shadow:0 0 15px rgba(239,70,110,.45); animation:markPulse 2s ease-in-out infinite; }
  @keyframes markPulse { 50% { transform:rotate(8deg) scale(1.12); } }
  .footer { margin-top:25px; font-size:.8rem; color:#b98796; }
  @media(max-width:560px) {
    .screen { padding:18px 12px; }
    .panel { padding:26px 18px; }
    .rose-vine { width:12vw; opacity:.55; }
    .letter-paper { max-height:89svh; padding:22px 18px; }
    .letter-paper p { font-size:.96rem; }
    .polaroid img, .polaroid .placeholder { height:220px; }
  }
  @media(prefers-reduced-motion: reduce) {
    *, *::before, *::after { animation-duration:.01ms !important; animation-iteration-count:1 !important; scroll-behavior:auto !important; transition-duration:.01ms !important; }
  }
</style>
</head>
<body>
  <!-- SCREEN 1: SECRET PASSWORD -->
  <section class="screen active" id="passwordScreen">
    <div class="panel">
      <div class="eyebrow">A little secret for you</div>
      <h1 class="glow">Before you come in… 🖤🍒</h1>
      <p>Some surprises are only for one special person.</p>
      <p class="tiny">Hint: Who is your special one?</p>
      <form id="passwordForm">
        <div class="password-wrap"><span class="lock">🔒</span><input id="passwordInput" type="password" placeholder="Enter the secret password" autocomplete="off" aria-label="Secret password"></div>
        <div class="actions"><button type="submit">UNLOCK MY SECRET ♡</button></div>
      </form>
      <div class="message" id="passwordMessage" aria-live="polite"></div>
    </div>
  </section>

  <!-- SCREEN 2: PLAYFUL YES / NO -->
  <section class="screen" id="questionScreen">
    <div class="panel">
      <div class="eyebrow">Be honest now…</div>
      <h1 class="glow">So I'm your special one right??? You got me 😉</h1>
      <p>Do you want to know what is waiting for you??</p>
      <div class="actions">
        <button id="firstYes">YES 💋</button>
        <button class="secondary" id="firstNo">NO 🙄</button>
      </div>
      <div class="message" id="firstNoMessage" aria-live="polite"></div>
    </div>
  </section>

  <!-- SCREEN 3: ENVELOPE -->
  <section class="screen" id="envelopeScreen">
    <div class="panel">
      <div class="eyebrow">Sealed with a little love</div>
      <h1 class="glow">A letter from me… 💌</h1>
      <p>There's something I've been wanting to tell you.</p>
      <div class="envelope-scene" id="envelopeScene" aria-label="An animated sealed envelope">
        <div class="envelope"><div class="letter-slip">A little piece of my heart ♡</div></div>
        <div class="flap"></div><div class="seal">❤️</div>
      </div>
      <div class="actions"><button id="openLetter">OPEN 💌</button></div>
      <p class="tiny">Take your time. This one's from my heart.</p>
    </div>
  </section>

  <!-- SCREEN 4: THE LETTER -->
  <section class="screen" id="letterScreen">
    <div class="rose-vine left" aria-hidden="true">
      <svg viewBox="0 0 150 900" preserveAspectRatio="none">
        <path d="M18 0 C95 100 25 180 95 280 S20 440 85 540 S28 720 105 900" fill="none" stroke="#31502c" stroke-width="5"/>
        <path d="M28 65 C80 60 87 105 95 125 M58 190 C10 180 10 220 35 242 M66 345 C120 325 123 365 103 390 M42 500 C4 470 2 520 28 542 M66 665 C118 640 126 680 100 706 M60 795 C15 770 12 815 40 835" fill="none" stroke="#527342" stroke-width="4"/>
        <g fill="#3b662f" stroke="#182d19" stroke-width="1"><ellipse cx="65" cy="83" rx="22" ry="10" transform="rotate(30 65 83)"/><ellipse cx="25" cy="218" rx="23" ry="10" transform="rotate(35 25 218)"/><ellipse cx="111" cy="356" rx="23" ry="10" transform="rotate(-35 111 356)"/><ellipse cx="19" cy="510" rx="23" ry="10" transform="rotate(35 19 510)"/><ellipse cx="111" cy="665" rx="23" ry="10" transform="rotate(-35 111 665)"/><ellipse cx="31" cy="802" rx="23" ry="10" transform="rotate(35 31 802)"/></g>
        <g fill="#9b1238" stroke="#ed7897" stroke-width="1.4"><circle cx="97" cy="143" r="19"/><circle cx="35" cy="261" r="17"/><circle cx="103" cy="409" r="20"/><circle cx="29" cy="559" r="18"/><circle cx="103" cy="728" r="20"/><circle cx="47" cy="857" r="18"/></g>
        <g fill="#e64a73"><circle cx="91" cy="138" r="7"/><circle cx="29" cy="256" r="6"/><circle cx="97" cy="403" r="7"/><circle cx="23" cy="553" r="6"/><circle cx="97" cy="722" r="7"/><circle cx="41" cy="851" r="6"/></g>
      </svg>
    </div>
    <div class="rose-vine right" aria-hidden="true">
      <svg viewBox="0 0 150 900" preserveAspectRatio="none">
        <path d="M18 0 C95 100 25 180 95 280 S20 440 85 540 S28 720 105 900" fill="none" stroke="#31502c" stroke-width="5"/>
        <path d="M28 65 C80 60 87 105 95 125 M58 190 C10 180 10 220 35 242 M66 345 C120 325 123 365 103 390 M42 500 C4 470 2 520 28 542 M66 665 C118 640 126 680 100 706 M60 795 C15 770 12 815 40 835" fill="none" stroke="#527342" stroke-width="4"/>
        <g fill="#3b662f" stroke="#182d19" stroke-width="1"><ellipse cx="65" cy="83" rx="22" ry="10" transform="rotate(30 65 83)"/><ellipse cx="25" cy="218" rx="23" ry="10" transform="rotate(35 25 218)"/><ellipse cx="111" cy="356" rx="23" ry="10" transform="rotate(-35 111 356)"/><ellipse cx="19" cy="510" rx="23" ry="10" transform="rotate(35 19 510)"/><ellipse cx="111" cy="665" rx="23" ry="10" transform="rotate(-35 111 665)"/><ellipse cx="31" cy="802" rx="23" ry="10" transform="rotate(35 31 802)"/></g>
        <g fill="#9b1238" stroke="#ed7897" stroke-width="1.4"><circle cx="97" cy="143" r="19"/><circle cx="35" cy="261" r="17"/><circle cx="103" cy="409" r="20"/><circle cx="29" cy="559" r="18"/><circle cx="103" cy="728" r="20"/><circle cx="47" cy="857" r="18"/></g>
        <g fill="#e64a73"><circle cx="91" cy="138" r="7"/><circle cx="29" cy="256" r="6"/><circle cx="97" cy="403" r="7"/><circle cx="23" cy="553" r="6"/><circle cx="97" cy="722" r="7"/><circle cx="41" cy="851" r="6"/></g>
      </svg>
    </div>
    <article class="letter-paper">
      <p class="letter-title">To my special one, 🖤🍒</p>

      <p>Soooo… you actually unlocked the website and made it this far? 👀</p>

      <p>First of all, congratulations, genius. And secondly… don't smile too much while reading this, okay? 😉❤️</p>

      <p>You know what's funny? Out of all the people in this world, somehow, you became <em>my person</em>. The one who can make me smile at the most random moments, the one who randomly pops into my mind when I'm doing absolutely nothing, and the one who makes ordinary little moments feel a little more special.</p>

      <p>And honestly? I kinda hate how effortlessly you do that. Like, excuse me sir, who gave you permission to live rent-free in my head? 😭🤌🏻</p>

      <p>But hey, I also know I'm not always the easiest person to deal with. Sometimes I get upset over little things, sometimes I start arguments, sometimes I overthink, and sometimes I might say something without realizing that it could hurt you.</p>

      <p><strong>And if I've ever made you feel sad, hurt you with my words, or made you feel like you weren't important to me, I'm genuinely sorry.</strong> 🥹❤️ That was never what I wanted. I might not always know how to express what I feel, but that doesn't mean I don't care. Your feelings matter to me too, and I never want you to feel like you have to hide them from me.</p>

      <p>And yes, I might annoy you, tease you, argue with you over the tiniest things, and then act like I did absolutely nothing wrong. 😭🤚🏻 But underneath all that, there's someone who genuinely cares about you and wants to see you happy.</p>

      <p>I don't know what the future has planned for us, and I'm not here to make a thousand promises. I just know that right now, you're someone special to me. I'm glad you're in my life, and I hope I can make you feel as special as you make me feel. ❤️</p>

      <p>So, if you ever wonder whether someone thinks about you, smiles because of you, or secretly wishes you the best in everything…</p>

      <p>Well, now you know. It's me, dummy. 🫵🏻😭💗</p>

      <p>And don't let this letter get to your head, okay? You're already annoying enough. 🙄💋</p>

      <p><strong>One last thing…</strong></p>

      <p>Whatever little arguments we have, I hope we never forget to listen to each other, understand each other, and choose kindness even when we're upset. We don't have to be perfect. We just have to be honest with each other. 🫶🏻</p>

      <p>And if you're smiling right now, just know that was the whole plan. And if you're blushing?</p>

      <p><strong>GOOD. MISSION SUCCESSFUL. 😌❤️‍🔥</strong></p>

      <p>And hey, if I've ever annoyed you too much, started unnecessary arguments, or hurt you even a little, I'm sorryyy, okay? 🥹❤️ I'm still your little troublemaker, so please forgive me. You can complain about me all you want, but unfortunately, you're stuck with my dramatic self now. 🤭💋 <strong>NO REFUNDS, NO EXCHANGES. TERMS AND CONDITIONS APPLY.</strong> 😭🤚🏻🍒</p>

      <p class="signature"><em>Yours in the most suspiciously affectionate way,</em><br><strong>Aleena ♡</strong></p>

      <p><em>P.S. I have another little surprise for you… but you'll have to keep going to find it. 😉🍒</em></p>
    </article>
    <div class="letter-actions"><button id="continueAfterLetter">CONTINUE 💋</button></div>
  </section>

  <!-- SCREEN 5: SECOND YES / NO -->
  <section class="screen" id="continueScreen">
    <div class="panel">
      <div class="eyebrow">One more little step…</div>
      <h1 class="glow">Do you want to continue??</h1>
      <div class="actions">
        <button id="continueYes">YES 💗</button>
        <button class="secondary" id="continueNo">NO 🙄</button>
      </div>
      <div class="message" id="continueNoMessage" aria-live="polite"></div>
    </div>
  </section>

  <!-- SCREEN 6: LITTLE MEMORIES -->
  <section class="screen" id="memoriesScreen">
    <div class="memories-wrap">
      <div class="eyebrow">Little moments, big feelings</div>
      <h1 class="glow">Little Memories 🍒</h1>
      <p>Some moments deserve a little place of their own. Tap a photo to see it closer. 🖤</p>
      <div class="polaroids" id="polaroidGallery"></div>
      <div class="panel next-note">
        <p>I want to tell you one more thing…</p>
        <p>Not here, baby. 🤭</p>
        <p>Come to the next page. 💋🍒</p>
        <button id="goFinal">NEXT →</button>
      </div>
      <p class="footer">Made with a little love, a little drama, and a lot of feelings. ♡</p>
    </div>
  </section>

  <!-- SCREEN 7: FINAL LOVE MESSAGE -->
  <section class="screen" id="finalScreen">
    <div class="panel">
      <div class="eyebrow">And finally…</div>
      <div class="final-heart">❤️</div>
      <p>Thank you for being in my life. ❤️</p>
      <h1 class="glow">I love you till my last breath…</h1>
      <h2>and I miss you. 🥹💋</h2>
      <div><span class="kiss-mark">💋</span><span class="kiss-mark">♥</span><span class="kiss-mark">💋</span></div>
      <p class="tiny">If I could, I'd send you a thousand kisses right now. 🍒</p>
      <button id="kissAgain">SEND MORE KISSES 💋</button>
      <p class="footer">Forever a little bit dramatic. ♡</p>
    </div>
  </section>

  <!-- PHOTO LIGHTBOX -->
  <div id="photoModal" role="dialog" aria-modal="true" aria-label="Memory photo" style="display:none; position:fixed; inset:0; z-index:30; background:rgba(5,0,2,.94); padding:22px; align-items:center; justify-content:center; flex-direction:column;">
    <button id="closeModal" class="secondary" style="position:absolute;top:18px;right:18px;">CLOSE ✕</button>
    <img id="modalImage" alt="A little memory" style="max-width:min(92vw,700px);max-height:72vh;object-fit:contain;border:8px solid #fff0ed;box-shadow:0 15px 50px #000;">
    <p id="modalCaption" style="text-align:center; margin-top:18px;"></p>
  </div>

<script>
  // Change these filenames/captions to match the photos you add to your GitHub repository.
  // Keep your pictures in a folder named "photos" beside this HTML file.
  const memories = [
    { image: "photos/photo1.jpg", caption: "A little moment I'll always remember. ♡" },
    { image: "photos/photo2.jpg", caption: "One of my favourite memories with you. 🍒" },
    { image: "photos/photo3.jpg", caption: "A moment that still makes me smile. 💗" }
  ];

  const screens = [...document.querySelectorAll(".screen")];
  function showScreen(id) {
    screens.forEach(screen => screen.classList.toggle("active", screen.id === id));
    window.scrollTo({ top: 0, behavior: "smooth" });
  }

  // Black hearts float only on the password entrance.
  let heartTimer = null;
  function startBlackHearts() {
    if (heartTimer) return;
    heartTimer = setInterval(() => {
      if (!document.getElementById("passwordScreen").classList.contains("active")) {
        clearInterval(heartTimer); heartTimer = null; return;
      }
      const heart = document.createElement("span");
      heart.className = "black-heart"; heart.textContent = "♥";
      heart.style.left = Math.random() * 100 + "vw";
      heart.style.fontSize = (12 + Math.random() * 20) + "px";
      heart.style.animationDuration = (6 + Math.random() * 6) + "s";
      document.body.appendChild(heart);
      setTimeout(() => heart.remove(), 13000);
    }, 550);
  }
  startBlackHearts();

  document.getElementById("passwordForm").addEventListener("submit", event => {
    event.preventDefault();
    const entered = document.getElementById("passwordInput").value.trim().toLowerCase();
    const message = document.getElementById("passwordMessage");
    if (entered === "aleena") {
      message.textContent = "";
      showScreen("questionScreen");
    } else {
      message.textContent = "Oopsie… that's not the secret, silly. Try again. 🥹🔐";
      document.getElementById("passwordInput").select();
    }
  });

  document.getElementById("firstYes").addEventListener("click", () => showScreen("envelopeScreen"));
  document.getElementById("firstNo").addEventListener("click", () => {
    document.getElementById("firstNoMessage").textContent = "Nice try. Now press YES. 😌💋";
  });

  document.getElementById("openLetter").addEventListener("click", () => {
    const envelope = document.getElementById("envelopeScene");
    envelope.classList.add("opened");
    document.getElementById("openLetter").disabled = true;
    document.getElementById("openLetter").textContent = "OPENED WITH LOVE ♡";
    setTimeout(() => showScreen("letterScreen"), 1350);
  });

  document.getElementById("continueAfterLetter").addEventListener("click", () => showScreen("continueScreen"));
  document.getElementById("continueYes").addEventListener("click", () => showScreen("memoriesScreen"));
  document.getElementById("continueNo").addEventListener("click", () => {
    document.getElementById("continueNoMessage").textContent = "Nice try. Now press YES. 😌💋";
  });
  document.getElementById("goFinal").addEventListener("click", () => {
    showScreen("finalScreen");
    setTimeout(makeKisses, 250);
    setTimeout(makeKisses, 800);
  });

  // Create the Polaroid cards from the memories array above.
  const gallery = document.getElementById("polaroidGallery");
  memories.forEach((memory, index) => {
    const card = document.createElement("div");
    card.className = "polaroid";
    card.setAttribute("role", "button");
    card.setAttribute("tabindex", "0");
    card.setAttribute("aria-label", "Open memory " + (index + 1));
    const img = document.createElement("img");
    img.src = memory.image;
    img.alt = memory.caption;
    const placeholder = document.createElement("div");
    placeholder.className = "placeholder";
    placeholder.innerHTML = "<span style='font-size:2.2rem'>🍒 ♡</span><span>Add your photo here</span><small style='opacity:.8'>photos/" + memory.image.split("/").pop() + "</small>";
    img.addEventListener("error", () => { img.style.display = "none"; placeholder.style.display = "flex"; });
    const caption = document.createElement("div");
    caption.className = "caption";
    caption.textContent = memory.caption;
    const open = () => {
      const modal = document.getElementById("photoModal");
      const modalImage = document.getElementById("modalImage");
      modalImage.src = memory.image;
      modalImage.style.display = img.style.display === "none" ? "none" : "block";
      document.getElementById("modalCaption").textContent = memory.caption;
      modal.style.display = "flex";
    };
    card.append(img, placeholder, caption);
    card.addEventListener("click", open);
    card.addEventListener("keydown", e => { if (e.key === "Enter" || e.key === " ") { e.preventDefault(); open(); } });
    gallery.appendChild(card);
  });

  function closeModal() { document.getElementById("photoModal").style.display = "none"; }
  document.getElementById("closeModal").addEventListener("click", closeModal);
  document.getElementById("photoModal").addEventListener("click", event => { if (event.target.id === "photoModal") closeModal(); });
  document.addEventListener("keydown", event => { if (event.key === "Escape") closeModal(); });

  function makeKisses() {
    if (!document.getElementById("finalScreen").classList.contains("active")) return;
    const symbols = ["💋", "💗", "😘", "❤️‍🔥"];
    for (let i = 0; i < 7; i++) {
      const kiss = document.createElement("span");
      kiss.className = "kiss";
      kiss.textContent = symbols[Math.floor(Math.random() * symbols.length)];
      kiss.style.left = (5 + Math.random() * 90) + "vw";
      kiss.style.top = (65 + Math.random() * 30) + "vh";
      kiss.style.setProperty("--dx", ((Math.random() - .5) * 45) + "vw");
      kiss.style.animationDelay = (Math.random() * .6) + "s";
      document.body.appendChild(kiss);
      setTimeout(() => kiss.remove(), 3000);
    }
  }
  document.getElementById("kissAgain").addEventListener("click", makeKisses);
</script>
</body>
</html>
