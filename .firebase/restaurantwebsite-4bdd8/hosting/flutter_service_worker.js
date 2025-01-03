'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "f611ad5ad4e5e4a138467e1ae5517cbd",
"assets/AssetManifest.bin.json": "6ee2aada579e215c7e70b34b1fbd668c",
"assets/AssetManifest.json": "6f73dca46ea7421281410873ebcd7e03",
"assets/assets/images/about_us.png": "53bfde6f2812bfd3be29c9bcc66f2ce2",
"assets/assets/images/appbar_logo.png": "cbf39530ef25aaea6973eba993231bc0",
"assets/assets/images/app_logo.png": "83c0453e47371860ab64463f6398a7c2",
"assets/assets/images/arrow_back.png": "beff933dfe8fffbb885377e9d8188fab",
"assets/assets/images/arrow_forward.png": "beebdbd2070dd4702a2803432fbaa9f9",
"assets/assets/images/back_arrow.png": "17437c14d131737f1e697f3d7ad9aee3",
"assets/assets/images/bg.png": "a60296078080bd88194dfa7a71c07781",
"assets/assets/images/btn_image.png": "438efb831fc6b526718a5dff2e2d2909",
"assets/assets/images/change_password.png": "c7fa62ecc476247df3b3fe1a39718a74",
"assets/assets/images/contact_us.png": "1de1f103bb76876de4a1d2717a99da0c",
"assets/assets/images/date_calender.png": "32d9e44574c999217716e3c7fff169a4",
"assets/assets/images/dish.png": "afb205095184b7d27e32b11541b75afb",
"assets/assets/images/dish1.png": "fcd6e50e632c22b9440eba68641e172e",
"assets/assets/images/dropdown2.png": "ebdcee76d65be827e470e4ad31a0fbfd",
"assets/assets/images/editing.png": "3705724d0c88aee08c24d058d1bba052",
"assets/assets/images/email_icon.png": "3a74b2319b4914afbdacf3bdf58f198b",
"assets/assets/images/green_star.png": "b9820cbf06d25a5489533c199cced4a1",
"assets/assets/images/home.png": "12259d55085d6c1c7a8d1a487d60bdc1",
"assets/assets/images/ihop-restaurant-logo%25201.png": "f69ff974f7bf13baf0174a9512ac30bf",
"assets/assets/images/image22.png": "a2e7d6a3eb7cc079fe11fd9864e44305",
"assets/assets/images/img1.png": "04b1058c0cda9638a21c88a12d4736fe",
"assets/assets/images/img12.png": "0e88aadc150eb663db907605fda98b7d",
"assets/assets/images/img3.png": "3e42328b6b6c492cd33651cc82be3d06",
"assets/assets/images/img4.png": "981ec6eb04283be54891aa4921b1f3d1",
"assets/assets/images/insta.png": "d7ddee8666d19de2dfc27e493b4cf4cf",
"assets/assets/images/key.png": "275e9210967b6903f8d74d781abe19e5",
"assets/assets/images/linkin.png": "81f96bbe36226e4b4f96e739edb2033b",
"assets/assets/images/logo.png": "550081382dd0250e6b0e41f37dc180b6",
"assets/assets/images/logout.png": "2645e3bd390526a4a79720de2553c9ca",
"assets/assets/images/menu1.png": "5fbfbfedf81b4414fa245eae6257b306",
"assets/assets/images/menu2.png": "e60ebdafee7d4edff28bc1d7c5144be3",
"assets/assets/images/menu3.png": "cfc062ad527753ac86ed8ff5e639598b",
"assets/assets/images/nav_about_active.png": "9da4f27bb13c93e40cc34a91355be0cb",
"assets/assets/images/nav_about_inactive.png": "aab1ab48702e5f8fc1f20b571b74b155",
"assets/assets/images/nav_archive_inactive.png": "25451f51c0aeed532d33c6cc7d7f015c",
"assets/assets/images/nav_contact_active.png": "0bb17068a3bfa5b5ae8026969ded50a9",
"assets/assets/images/nav_dashboard_active.png": "5ed75ddbc423921a5a56fc70c89f51e4",
"assets/assets/images/nav_dashboard_inactive.png": "1843540232b80074c85ab34786acdba3",
"assets/assets/images/nav_privacy_active.png": "32488daf0c2e0f05f451fab862783e47",
"assets/assets/images/nav_privacy_inactive.png": "53cbc8385a96a0bb7780f7eddc7763c3",
"assets/assets/images/nav_profile_active.png": "2bceb1e44b76ffc63d9924cacca59599",
"assets/assets/images/nav_profile_inactive.png": "cc0f61ebd0f3ede86d7283ecacb14576",
"assets/assets/images/nav_restaurant_active.png": "942d08b7379777c0a42627ce51c463f3",
"assets/assets/images/nav_restaurant_inactive.png": "70b23fa46048741358373107df0e2b7c",
"assets/assets/images/nav_terms_active.png": "277339ea92b49ce98eaefd5fb3fe5f83",
"assets/assets/images/nav_terms_inactive.png": "442fc60f4cc1bed26040cb54134b27d2",
"assets/assets/images/nav_user_active.png": "2bceb1e44b76ffc63d9924cacca59599",
"assets/assets/images/nav_user_inactive.png": "cc0f61ebd0f3ede86d7283ecacb14576",
"assets/assets/images/p1.png": "065e24a7d3b001999fd89f6399c26559",
"assets/assets/images/phone_icon.png": "9311300efbf47667cf4f4b58e9131ba9",
"assets/assets/images/privacy.png": "df860e0ff9d33eb3a9991ab2a9fdaf70",
"assets/assets/images/pro.png": "ccac3312022f2b06431d513a0be5262d",
"assets/assets/images/pro2.png": "b1157185b0d55e411f1282f9ed398ebc",
"assets/assets/images/profile.png": "c4bb2a05fe16fee878590fb8b728e544",
"assets/assets/images/profile_pic.png": "1452fe87803c5d811c5e372d5d3ebeb9",
"assets/assets/images/resturant_detail.png": "6a777d1ffe4677fccd8a17f218ce349a",
"assets/assets/images/send_icon.png": "52780556e5cea6fbfae262eae38644e4",
"assets/assets/images/star%2520yellow.png": "1d438ea79ff1e3e1ac0f75bf191da3a4",
"assets/assets/images/star_empty.png": "5fc2ae9e488f420ddfc75fa268a69098",
"assets/assets/images/star_img.png": "4665aea00a02095c050dab235123ba5a",
"assets/assets/images/star_img2.png": "641581e4f198e305b1ce65439d53ca67",
"assets/assets/images/terms.png": "c34ba89a666db0276ed768ab3bbef0af",
"assets/assets/images/tick_image.png": "c346953e4f1c75f8cbd5a17999d67eb7",
"assets/assets/images/x_icon.png": "6675745bf93b8b9c347c62a4df0791d9",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "70f51f4341735b56d22b02d51b3f818d",
"assets/NOTICES": "4a0ac638a3e0bd0e2cfc70ebaa10ad92",
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
"flutter_bootstrap.js": "bb11b41ea44c81a3d57874f3d336a90c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "50f3a1fef3526644bcd2178e3f272447",
"/": "50f3a1fef3526644bcd2178e3f272447",
"main.dart.js": "9219d6fd033f9de56dc251bc33874ddd",
"manifest.json": "6561619d02559caf1ebb136c89148003",
"version.json": "ffd8d74b336013539bda1fcbaaf2ec6a"};
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
