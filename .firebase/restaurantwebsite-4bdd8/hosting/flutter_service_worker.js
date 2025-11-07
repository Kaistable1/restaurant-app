'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "871f7ff37bcd1b4514443401948b255e",
"version.json": "ffd8d74b336013539bda1fcbaaf2ec6a",
"index.html": "4641a14d556d5015a2ae032a09173281",
"/": "4641a14d556d5015a2ae032a09173281",
"main.dart.js": "94082b4ba72d19a236bbd1e5419c41b3",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "6561619d02559caf1ebb136c89148003",
"assets/AssetManifest.json": "8b23b9df51e7ecde6f0569ded54a8587",
"assets/NOTICES": "7a6632ba626bfb13bb1fe1658498836b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "faa2f372cbd9c1e7d1618c40040b2c85",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "2bd196efe8ba4cdb7cb13b9229611420",
"assets/fonts/MaterialIcons-Regular.otf": "3af950ee0045d77deeb0e886cb31cbe6",
"assets/assets/images/selected_event_icon.png": "13384fad356297a68ecf52accf08b601",
"assets/assets/images/upload_doc.png": "6fa6369020f1f3a7ffc2850be363d8b6",
"assets/assets/images/event_img5.png": "56b8d724523931dcb72cd721a44ad3eb",
"assets/assets/images/editing.png": "3705724d0c88aee08c24d058d1bba052",
"assets/assets/images/event_img4.png": "fd42a4274395309a17e318e19a8beed5",
"assets/assets/images/forgot_background.png": "897500ce4faa5deeeea0287bfe6306ff",
"assets/assets/images/background_green.png": "5df8791d21ab5237fcd0c9d602ed9f80",
"assets/assets/images/notifications_icon.png": "356aa4fd79263e550eb05fd97b219779",
"assets/assets/images/event_img6.png": "42d09856f3c388e62dcfc6be920b802b",
"assets/assets/images/event_img7.png": "e1606dced51e049f753f59dbac0b9454",
"assets/assets/images/profile_img.png": "3734091e0777f1ef6b3c9a3d6e12508a",
"assets/assets/images/event_img3.png": "ef58a45ea6f7e786a06f60b5daf6ef8b",
"assets/assets/images/aerrow.png": "3577ad17b88a9c48f63220c380fe1eb4",
"assets/assets/images/claims_icon.png": "1dbd47ad98319276fa5f27b56ece5f6e",
"assets/assets/images/dish1.png": "fcd6e50e632c22b9440eba68641e172e",
"assets/assets/images/nav_dashboard_active.png": "5ed75ddbc423921a5a56fc70c89f51e4",
"assets/assets/images/nav_restaurant_inactive.png": "70b23fa46048741358373107df0e2b7c",
"assets/assets/images/arrow_drop.png": "cb3cb90001a96e3ea2add31ce2cd68db",
"assets/assets/images/dash_con_1_icons.png": "2d22f2cb166d6163e167efe46b95dbbc",
"assets/assets/images/profile_image.png": "eb870e16f04e1dc1ee6b08df05bb8a62",
"assets/assets/images/selected_dashboard_icon.png": "e74016cbab7363256836f085cee7a9f5",
"assets/assets/images/terms.png": "c34ba89a666db0276ed768ab3bbef0af",
"assets/assets/images/key.png": "275e9210967b6903f8d74d781abe19e5",
"assets/assets/images/sub_admin_icon.png": "3c3d19c8a8f4cf51bca04f5bbdb65324",
"assets/assets/images/selected_privacy_icon.png": "e20a84758eb94ff72c6e381b26f05578",
"assets/assets/images/nav_about_active.png": "9da4f27bb13c93e40cc34a91355be0cb",
"assets/assets/images/dashboard_icon.png": "ed3ce28a182bb965f15d8dc80948abe1",
"assets/assets/images/completed_restaurants_icon..png": "a265b85ff407a9cc9fdf353289dbcac8",
"assets/assets/images/selected_sub_admin_icon.png": "ca197545cdae763eb3fa70b1700ce9f0",
"assets/assets/images/back_arrow.png": "6db5a75c1437e1610e8ea80923b0b068",
"assets/assets/images/ava.png": "1cb406b4baf76409278ed7fd5e5f6a3b",
"assets/assets/images/arrow_back.png": "beff933dfe8fffbb885377e9d8188fab",
"assets/assets/images/nav_user_inactive.png": "cc0f61ebd0f3ede86d7283ecacb14576",
"assets/assets/images/logout.png": "2645e3bd390526a4a79720de2553c9ca",
"assets/assets/images/dropdown2.png": "ebdcee76d65be827e470e4ad31a0fbfd",
"assets/assets/images/event_im1.png": "823c1468b441064500b9e8aac3f7bd59",
"assets/assets/images/event_img.png": "2590c8e3eea616a3a1d7b0fccdd04781",
"assets/assets/images/cam_icon.png": "623a524360f80cd64a77eea4099110bd",
"assets/assets/images/event_ing2.png": "035e228ef92c481d10486d3294aa14f4",
"assets/assets/images/banner_icon.png": "473312727672d0e64f630d6326da3f14",
"assets/assets/images/home.png": "12259d55085d6c1c7a8d1a487d60bdc1",
"assets/assets/images/star_img.png": "4665aea00a02095c050dab235123ba5a",
"assets/assets/images/send_icon.png": "52780556e5cea6fbfae262eae38644e4",
"assets/assets/images/privacy_icon.png": "4aa7349c1b7d3ba7dac2027e31c32e4f",
"assets/assets/images/arrow_down_icon.png": "ce5b7aced1b84cd19fafc9c2a63ae9e6",
"assets/assets/images/selected_fork_icon.png": "dc861d8bb0c9eb296045c7181263c4c6",
"assets/assets/images/event_map.png": "9c8cd8d3ac73ec5468b56fceaa9751b8",
"assets/assets/images/about_us.png": "53bfde6f2812bfd3be29c9bcc66f2ce2",
"assets/assets/images/info_icon.png": "977c7beda4430a0843540718038c169b",
"assets/assets/images/email_img.png": "42f6b6c649ab838ce1e5f42232bff3b0",
"assets/assets/images/linkin.png": "81f96bbe36226e4b4f96e739edb2033b",
"assets/assets/images/nav_about_inactive.png": "aab1ab48702e5f8fc1f20b571b74b155",
"assets/assets/images/menu3.png": "cfc062ad527753ac86ed8ff5e639598b",
"assets/assets/images/privacy.png": "df860e0ff9d33eb3a9991ab2a9fdaf70",
"assets/assets/images/nav_profile_inactive.png": "cc0f61ebd0f3ede86d7283ecacb14576",
"assets/assets/images/nav_profile_active.png": "2bceb1e44b76ffc63d9924cacca59599",
"assets/assets/images/profile_top_img.png": "2e7ca145a62e59a1984acef2a0cb9731",
"assets/assets/images/nav_restaurant_active.png": "942d08b7379777c0a42627ce51c463f3",
"assets/assets/images/phone_img.png": "d16101424d442a1463b0202bb52f48e6",
"assets/assets/images/star_img2.png": "641581e4f198e305b1ce65439d53ca67",
"assets/assets/images/img4.png": "981ec6eb04283be54891aa4921b1f3d1",
"assets/assets/images/pro2.png": "b1157185b0d55e411f1282f9ed398ebc",
"assets/assets/images/menu2.png": "e60ebdafee7d4edff28bc1d7c5144be3",
"assets/assets/images/map_img.png": "43a2e971815d0d48b064e096f79d9a75",
"assets/assets/images/nav_dashboard_inactive.png": "1843540232b80074c85ab34786acdba3",
"assets/assets/images/image22.png": "a2e7d6a3eb7cc079fe11fd9864e44305",
"assets/assets/images/event_icon.png": "dc6f95027710992cf98b5c91b641b2b9",
"assets/assets/images/notification_icon.png": "fb3748ababfe66721d8ea8f19292a274",
"assets/assets/images/nav_privacy_inactive.png": "53cbc8385a96a0bb7780f7eddc7763c3",
"assets/assets/images/nav_terms_inactive.png": "442fc60f4cc1bed26040cb54134b27d2",
"assets/assets/images/menu1.png": "5fbfbfedf81b4414fa245eae6257b306",
"assets/assets/images/arrow_forward.png": "beebdbd2070dd4702a2803432fbaa9f9",
"assets/assets/images/profile_pic.png": "1452fe87803c5d811c5e372d5d3ebeb9",
"assets/assets/images/logo.png": "550081382dd0250e6b0e41f37dc180b6",
"assets/assets/images/p1.png": "065e24a7d3b001999fd89f6399c26559",
"assets/assets/images/selected_banner_icon.png": "f9e32ed0e31ec9483bf6d2f5d61a939f",
"assets/assets/images/img3.png": "3e42328b6b6c492cd33651cc82be3d06",
"assets/assets/images/star%2520yellow.png": "1d438ea79ff1e3e1ac0f75bf191da3a4",
"assets/assets/images/dash_con_3_icons.png": "14589867a3709c245c62547f89668e82",
"assets/assets/images/selected_terms_icon.png": "e78e3df542594dd9b1bd1309cc40e6d5",
"assets/assets/images/insta.png": "d7ddee8666d19de2dfc27e493b4cf4cf",
"assets/assets/images/x_icon.png": "6675745bf93b8b9c347c62a4df0791d9",
"assets/assets/images/selected_contact_icon.png": "dde4bf107120212fda29a7652fc9e34f",
"assets/assets/images/selected_about_icon.png": "7861d0d9ddac723a42a32ef52879d478",
"assets/assets/images/profile.png": "c4bb2a05fe16fee878590fb8b728e544",
"assets/assets/images/map_event.png": "28844c84c5f098a6279fdf47f3d76bb3",
"assets/assets/images/email_icon.png": "3a74b2319b4914afbdacf3bdf58f198b",
"assets/assets/images/banner_img.png": "cea5e54097750f2a2e46125c34fd84a6",
"assets/assets/images/resturant_detail.png": "6a777d1ffe4677fccd8a17f218ce349a",
"assets/assets/images/change_password.png": "c7fa62ecc476247df3b3fe1a39718a74",
"assets/assets/images/star_empty.png": "5fc2ae9e488f420ddfc75fa268a69098",
"assets/assets/images/logo_img_.png": "1a7376ca42315b42e6ae6b080c07e03e",
"assets/assets/images/img1.png": "04b1058c0cda9638a21c88a12d4736fe",
"assets/assets/images/app_logo.png": "83c0453e47371860ab64463f6398a7c2",
"assets/assets/images/date_calender.png": "32d9e44574c999217716e3c7fff169a4",
"assets/assets/images/nav_terms_active.png": "277339ea92b49ce98eaefd5fb3fe5f83",
"assets/assets/images/dash_con_4_icons.png": "7915e1babb4d0f3c65c8b804fb14bb3e",
"assets/assets/images/res_table_4.png": "90fbb0dcad902372990e6d8fe1793cf8",
"assets/assets/images/contact_us.png": "6a58d5134a88801e0ea109090be1689e",
"assets/assets/images/nav_contact_active.png": "0bb17068a3bfa5b5ae8026969ded50a9",
"assets/assets/images/dish.png": "afb205095184b7d27e32b11541b75afb",
"assets/assets/images/nav_privacy_active.png": "32488daf0c2e0f05f451fab862783e47",
"assets/assets/images/tick_image.png": "c346953e4f1c75f8cbd5a17999d67eb7",
"assets/assets/images/appbar_logo.png": "cbf39530ef25aaea6973eba993231bc0",
"assets/assets/images/phone_icon.png": "9311300efbf47667cf4f4b58e9131ba9",
"assets/assets/images/ihop-restaurant-logo%25201.png": "f69ff974f7bf13baf0174a9512ac30bf",
"assets/assets/images/profile___imgg.png": "eee2837075907a800cf9abec4a7c9179",
"assets/assets/images/dash_con_2_icons.png": "7e7f7b2fda0830ab73c9bd503f104d7b",
"assets/assets/images/terms-and-conditions%2520_icon.png": "a8e4fe8169fe98b4e5339a6277158423",
"assets/assets/images/res_table_3.png": "f31604c7860efb30f5f38b435d30d35d",
"assets/assets/images/selected_claims_icon.png": "a70b8023ccacd71617a016d9083f378f",
"assets/assets/images/green_star.png": "b9820cbf06d25a5489533c199cced4a1",
"assets/assets/images/res_table_2.png": "aa40f4e1b99bb445519c17165251cc2c",
"assets/assets/images/restaurant_details_img.png": "7e5ae39f4e5b3508b064e42306dea051",
"assets/assets/images/drawer_fork_icon.png": "ece5caa67a62f73ac5841b6a8418b619",
"assets/assets/images/nav_user_active.png": "2bceb1e44b76ffc63d9924cacca59599",
"assets/assets/images/img12.png": "0e88aadc150eb663db907605fda98b7d",
"assets/assets/images/nav_archive_inactive.png": "25451f51c0aeed532d33c6cc7d7f015c",
"assets/assets/images/liam.png": "00811867c0442ca5e5e4fcbd98b515d7",
"assets/assets/images/pro.png": "ccac3312022f2b06431d513a0be5262d",
"assets/assets/images/event_img8.png": "80dcab54081382f629f5336a9951c203",
"assets/assets/images/greenBackground.png": "abc9165b30a6b18d978ddcbf1293f069",
"assets/assets/images/welcome.png": "7606ceb0275c09c96874c212a67c7dfd",
"assets/assets/images/res_table_1.png": "58aefa721d9c9c631f6a2f673e122c69",
"assets/assets/images/bg.png": "a60296078080bd88194dfa7a71c07781",
"assets/assets/images/darlene.png": "4edc4292d7b95068fee70e63c9530994",
"assets/assets/images/btn_image.png": "438efb831fc6b526718a5dff2e2d2909",
"assets/assets/countries.json": "749b93bc81bc59bfe645ed591805ac4d",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93"};
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
