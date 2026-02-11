import Foundation

struct WindArticle: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}

struct WindArticleData {
    static let articles: [WindArticle] = [
        WindArticle(
            title: "North Wind Tactics",
            body: "A north wind in winter typically signals the arrival of a cold front, pushing arctic air southward across frozen lakes. Fish respond to these pressure changes by moving to deeper water and becoming less active. However, experienced anglers know that the period just before a north wind arrives can trigger aggressive feeding. Position yourself on the south shore where wind-driven currents push baitfish and plankton. Use slower presentations and downsize your lures. Tip-ups with live bait work exceptionally well during north wind conditions. The key is patience: fish in north winds tend to bite in short, concentrated windows rather than throughout the day. Monitor your electronics closely for brief flurries of activity near the bottom."
        ),
        WindArticle(
            title: "How Wind Affects Under-Ice Currents",
            body: "Even beneath a solid ice sheet, wind creates measurable water movement. Strong sustained winds push surface water in one direction, and the displaced water must return along the bottom or sides, creating circulation patterns beneath the ice. These under-ice currents redistribute dissolved oxygen, carry plankton and invertebrates, and influence where fish stage. On large lakes, a steady wind can create a current of several centimeters per second under the ice, enough to concentrate food along specific shorelines and structural features. Fish instinctively position themselves where current funnels food to them, similar to trout in a stream facing into current. Drilling test holes along suspected current paths and using a small float or piece of line to detect flow direction can reveal these productive underwater highways."
        ),
        WindArticle(
            title: "Reading Wind for Feeding Zones",
            body: "The downwind shore of any body of water becomes the primary feeding zone during sustained winds. Wind pushes surface water, plankton, algae, and microscopic organisms toward the downwind bank. Small baitfish follow this food source, and predatory fish follow the baitfish. Under ice, this effect is dampened but still significant on larger bodies of water. When scouting a new lake, observe the prevailing wind direction and focus your first holes on the downwind side. Points and inside turns on the downwind shore concentrate food even further, creating hotspots. If the wind shifts during the day, be prepared to move. Fish will gradually reposition over one to three hours following a significant wind direction change. The corners where wind hits a shoreline at an angle are particularly productive."
        ),
        WindArticle(
            title: "Wind Chill Safety Thresholds",
            body: "Wind chill is the single most dangerous factor for ice anglers. At an air temperature of minus ten degrees Celsius, a moderate wind of twenty kilometers per hour drops the effective temperature to minus eighteen. At minus twenty with strong gusts, exposed skin can develop frostbite in under ten minutes. Critical safety thresholds every ice angler must know: at minus twenty-five wind chill, limit exposure time to thirty minutes without shelter. At minus thirty-five, frostbite risk becomes severe within ten minutes on exposed skin. At minus forty-five, conditions are life-threatening and fishing should be postponed. Always carry emergency hand warmers, a charged phone, and inform someone of your location and expected return time. A proper ice shelter reduces wind chill to near zero inside, making the difference between a dangerous outing and a comfortable one."
        ),
        WindArticle(
            title: "Best Wind Conditions by Species",
            body: "Different fish species respond to wind conditions in distinct ways. Walleye feed most aggressively during light to moderate winds from the south or southwest, which often accompany stable or rising barometric pressure. Perch schools become more active and concentrated along windward shorelines during moderate winds, making them easier to locate. Northern pike are opportunistic and feed well in most wind conditions, but a light north wind following a warm spell can trigger exceptional pike activity in shallow bays. Trout in stocked lakes respond positively to light winds that create subtle current under the ice, activating their instinct to face into flow. Crappie prefer calm to light wind conditions and often suspend mid-column; strong winds push them toward sheltered bays and deeper structure. Bluegill and panfish generally feed best on calm days or during very light winds when they can hold position easily near weed edges."
        ),
        WindArticle(
            title: "Shelter Setup in High Wind",
            body: "Proper shelter positioning in high wind is both a safety concern and a fishing strategy advantage. Always anchor your shelter with ice anchors or heavy-duty screw-in stakes, not just the weight of the shelter itself. Winds above forty kilometers per hour can flip an unsecured pop-up shelter across the ice. Orient the entrance away from the wind and slightly to one side so gusts do not funnel directly inside. If using a hub-style shelter, the strongest orientation places a flat wall facing the wind rather than a corner. Use a sled or gear bag as additional wind block at the entrance. Inside your shelter, the reduced wind chill allows you to fish with bare hands for better sensitivity. Position your holes slightly off-center toward the downwind wall so any drafts from seams do not freeze your line. Guy lines attached to ice anchors at forty-five degree angles provide the best hold in sustained high winds."
        ),
        WindArticle(
            title: "Wind and Ice Thickness",
            body: "Wind has a direct and often underestimated effect on ice formation and thickness. Exposed areas with consistent wind develop ice more slowly because wind creates waves and surface agitation that resist freezing. Sheltered bays and coves freeze first and build thicker ice throughout the season. On large lakes, prevailing winds can push ice sheets, creating pressure ridges where plates collide and open water leads where they separate. These pressure ridges are extremely dangerous to cross and can open without warning during windy periods. Wind also affects snow distribution on ice: windswept areas with thin snow cover develop thicker, clearer ice because the insulating snow layer is removed. Conversely, drifted snow areas may have thinner ice beneath. Always check ice thickness in multiple locations, especially when transitioning from sheltered to wind-exposed areas. A minimum of ten centimeters of clear ice is recommended for foot travel."
        ),
        WindArticle(
            title: "Calm Day Strategies",
            body: "Calm days on the ice present a unique set of challenges and opportunities. Without wind-driven currents to concentrate food, fish disperse more evenly across a body of water, making them harder to locate. However, calm conditions often coincide with stable barometric pressure, which generally promotes steady feeding activity. On calm days, focus on structural elements that naturally concentrate fish: drop-offs, underwater points, weed edges, and rock piles. These features provide the ambush points that wind-driven food concentrations normally create along shorelines. Calm days are ideal for sight fishing through clear ice, as the water beneath is undisturbed and visibility improves. Sound travels more effectively through calm water, so use quieter approaches and lighter jigging motions. Electronics become even more valuable on calm days for marking scattered fish. Drill more holes than usual and stay mobile, checking each location for ten to fifteen minutes before moving to cover more water."
        ),
        WindArticle(
            title: "Wind Direction Changes During the Day",
            body: "Wind rarely blows from a constant direction throughout an entire fishing day. Morning thermals, passing weather systems, and local geography all cause shifts. Understanding these patterns gives you a significant advantage. In stable weather, light offshore breezes often develop overnight and through early morning as land cools faster than water. By midmorning, as the sun warms the land, wind typically shifts to blow onshore. This predictable pattern means the prime feeding zone migrates during the day. A common mistake is setting up on the morning hotspot and staying all day as conditions change. Experienced anglers monitor wind shifts and relocate accordingly. When a major front passes, wind can rotate dramatically from south to northwest within hours. Fish often stop feeding during the actual shift and resume once the new wind stabilizes. Keep a mental note of wind direction every hour and correlate it with your catch rate to build a personal pattern database over the season."
        ),
        WindArticle(
            title: "Using Wind to Find Fish",
            body: "Wind is one of the most reliable natural indicators for locating fish on unfamiliar water. Before drilling a single hole, observe the landscape: note which shore the wind is hitting and identify structural features on that downwind side. Points that jut into the wind-driven current are prime starting locations. Inside bends of the downwind shoreline create natural collection areas for drifting food particles. If you can see the bottom through the ice, look for debris lines where wind-pushed material has settled; fish cruise these lines feeding. On larger lakes, wind creates seams where moving water meets calm pockets behind islands or points. These current seams are underwater buffet lines for gamefish. When the wind has been blowing from the same direction for two or more days, food concentration on the downwind side intensifies. Long-term wind patterns are more productive than a recent shift because it takes time for the biological food chain to reposition. Use the wind as your first filter, then refine with electronics and test holes."
        )
    ]
}
