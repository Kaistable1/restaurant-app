'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "50e3c7b166865f22cd07cd0fe9f7b8c8",
"assets/AssetManifest.bin.json": "71c9877a4fb6ac91a02dbc9f42cb90e1",
"assets/AssetManifest.json": "d3c4886401615f6b2907c07dc4a07621",
"assets/assets/fonts/aftika-bold.otf": "496fd56915ac8d50e5af9cc220bb7775",
"assets/assets/fonts/aftika-extralight.otf": "2e3d52997b73c547d27ab4aee8b23299",
"assets/assets/fonts/aftika-regular.otf": "c69ffff0698ddcfea023a6f0a3836f68",
"assets/assets/fonts/Lemonado.otf": "4631bd7364af4551025e0d18a7969495",
"assets/assets/fonts/Lora-Bold.ttf": "eb2b8c98a8fc70a6cf461d7ead627e9e",
"assets/assets/fonts/Lora-Regular.ttf": "c87345ceb65eb56514768c598074a102",
"assets/assets/fonts/NunitoSans-Bold.ttf": "51066f4d1d33630cd761e8cd0168d7b0",
"assets/assets/fonts/NunitoSans-ExtraLight.ttf": "bc36a8726e20804a94da3a12bd6eda84",
"assets/assets/fonts/NunitoSans-Regular.ttf": "fb98ed1700e8dfaf0764c11fc36a0a05",
"assets/assets/images/aa.png": "22488519a9ce15153cc3d2e98a2b36de",
"assets/assets/images/appstore_img.png": "ddf4030c4a1fbb443285cec8120b3e09",
"assets/assets/images/arrow_back.png": "14b47c54b190ca9e75763edc4889b3af",
"assets/assets/images/arrow_forward.png": "e04a31c2de9c6c016395f5703f274f0d",
"assets/assets/images/botm_corner_img.png": "afae1aed8b121a1149a9b958520812d3",
"assets/assets/images/botm_rectangle.png": "b156d730ca618948cb86da1c2b297afd",
"assets/assets/images/botomsheet_logo.png": "156b4a919123d20773a481af0f6e42ed",
"assets/assets/images/circle_img.png": "69a6c2e288a1579cfa9498f070bb6ac4",
"assets/assets/images/circle_img2.png": "1c3989a469ab35a9ef246afef7b8e4d8",
"assets/assets/images/circle_img3.png": "22488519a9ce15153cc3d2e98a2b36de",
"assets/assets/images/corner_image.png": "2f84fcc2b0371b8f6e9bd47c9d7e7376",
"assets/assets/images/dialogbox_img.png": "91f4c3be4d60eec01188536b50117e92",
"assets/assets/images/divider_line.png": "7a188d456831a4e2d12cc37a3e3e123c",
"assets/assets/images/document-upload.png": "12e3c953ac4e1d50c9149d2514d73731",
"assets/assets/images/drop_down_img.png": "497e2fe88f71556f3714fbc564fc06e1",
"assets/assets/images/email_icon.png": "14ba95b02cd18120dc3d0cd6309a7095",
"assets/assets/images/email_icon_black.png": "32ca76cc9665cfbc308d69b72054af18",
"assets/assets/images/facebook_img.png": "045a5d015b344c9e8460375a47fc3b9b",
"assets/assets/images/facebook_light.png": "f1bdd28f62ff0d90cdee1282df541da4",
"assets/assets/images/filter_img.png": "ce522f0ba500badf044ab7acc504f2b7",
"assets/assets/images/googleplay_img.png": "0b07e938ced260d193e455832e99fa49",
"assets/assets/images/heart_icon.png": "c4b97de258fa0545e781637a3be75fc1",
"assets/assets/images/heart_white_icon.png": "6bb1bd58b829b5991f2e26914ad0e613",
"assets/assets/images/home_background_img.png": "31d5a93722b1e1de6381fd2eccb2e2fa",
"assets/assets/images/ihop-restaurant-logo%25201.png": "f69ff974f7bf13baf0174a9512ac30bf",
"assets/assets/images/img1.png": "4016f46b25cb6cda63dcd2c4a4510bfc",
"assets/assets/images/insta_img.png": "554b7168262a891516ceaec65495f1de",
"assets/assets/images/insta_light.png": "298197a026e61fca69199bb088513178",
"assets/assets/images/linkedin_img.png": "78ffa018aeb407e7c2b17de81f8ae38f",
"assets/assets/images/linkedin_light.png": "414d4d23b0537941fde43b058af70275",
"assets/assets/images/location_icon.png": "bc534aeceb40c160fad2a2ca776b3101",
"assets/assets/images/location_img1.png": "70a336f459abaf093e756fe0a3e07c96",
"assets/assets/images/location_img2.png": "22488519a9ce15153cc3d2e98a2b36de",
"assets/assets/images/location_img3.png": "2659c6f490749c14728e4dc1e92f439c",
"assets/assets/images/menu1.png": "5fbfbfedf81b4414fa245eae6257b306",
"assets/assets/images/menu2.png": "e60ebdafee7d4edff28bc1d7c5144be3",
"assets/assets/images/menu3.png": "cfc062ad527753ac86ed8ff5e639598b",
"assets/assets/images/mobile_screen_img.png": "89714b2605747783f348e6e9aab44434",
"assets/assets/images/onboarding_background.png": "f4fae75dff55074af9a15aac9cc22892",
"assets/assets/images/onboarding_container_img.png": "97607c9d6330bd31c9705f1dd6188088",
"assets/assets/images/onboarding_top2.png": "6adb47c6ff043e35eb4fb371fcf4bcf1",
"assets/assets/images/phone_icon.png": "e5bf043705a142c4f5528e0548b0006b",
"assets/assets/images/plate_img.png": "0512baf3c5b1013cf7a4bdc1c5453219",
"assets/assets/images/search_black_icon.png": "864ca962476821e235138452ce980ec0",
"assets/assets/images/search_icon.png": "e8f05c12fc67c8d30991ba623a11cad4",
"assets/assets/images/star%2520yellow.png": "1d438ea79ff1e3e1ac0f75bf191da3a4",
"assets/assets/images/star_empty.png": "5fc2ae9e488f420ddfc75fa268a69098",
"assets/assets/images/star_img.png": "4665aea00a02095c050dab235123ba5a",
"assets/assets/images/star_img2.png": "641581e4f198e305b1ce65439d53ca67",
"assets/assets/images/topbar_logo.png": "a75573ce33eb48fab61644b300b8771d",
"assets/FontManifest.json": "081440b631fbc32830a1a890a3f1ca6d",
"assets/fonts/MaterialIcons-Regular.otf": "b4cc6f4683ccf620a3371ec2f05bdd2b",
"assets/NOTICES": "dfdbbbaccf54ea71299caef5185e02ac",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "e7eaf85c6e85a3eb427de0a356bf07f0",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "7a3fc6d408e689d03fc782924d7c26a3",
"/": "7a3fc6d408e689d03fc782924d7c26a3",
"main.dart.js": "9a71051c0822c181bdd39c9e2a9a786b",
"manifest.json": "07c4c7384b25f17ee04b554c4bb44543",
"version.json": "81e7b8b873d092feb3b3451161567dfc"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
