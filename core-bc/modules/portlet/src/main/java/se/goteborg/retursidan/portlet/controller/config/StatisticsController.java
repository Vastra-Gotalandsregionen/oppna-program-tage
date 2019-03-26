package se.goteborg.retursidan.portlet.controller.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import se.goteborg.retursidan.model.entity.Area;
import se.goteborg.retursidan.model.entity.Unit;
import se.goteborg.retursidan.portlet.controller.BaseController;
import se.goteborg.retursidan.service.StatisticsService;
import se.goteborg.retursidan.service.VisitorLoggingService;

import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("EDIT")
public class StatisticsController extends BaseController {
    Logger logger = LoggerFactory.getLogger(this.getClass().getName());

	@Autowired
	private VisitorLoggingService visitorLogging;
	
	@Autowired
	private StatisticsService statisticsService;
	
	@RenderMapping(params="page=statistics")
	public String showStatistics(RenderRequest request, RenderResponse response, Model model) {
		Integer uniqueVisitors = visitorLogging.getUniqueVisitors();
		model.addAttribute("uniqueVisitors", uniqueVisitors);
		
		List<Unit> units = modelService.getUnits();
		model.addAttribute("units", units);

		List<Area> areas = modelService.getAreas();
		model.addAttribute("areas", areas);

		Map<Integer, Integer> totalNumberOfAds = statisticsService.getTotalNumberOfAds();
		model.addAttribute("totalNumberOfAds", totalNumberOfAds);
		List<Map<Integer, Integer>> unitAdCount = new ArrayList<>();
		for (Unit unit : units) {
			Map<Integer, Integer> count = statisticsService.getTotalAdsForUnit(unit);
			unitAdCount.add(count);
		}
		model.addAttribute("unitAdCount", unitAdCount);

		Map<Integer, Integer> totalNumberOfAreaAds = statisticsService.getTotalNumberOfAdsWithArea();
		model.addAttribute("totalNumberOfAreaAds", totalNumberOfAreaAds);
		List<Map<Integer, Integer>> areaAdCount = new ArrayList<>();
		for (Area area : areas) {
			Map<Integer, Integer> count = statisticsService.getTotalAdsForArea(area);
			areaAdCount.add(count);
		}
		model.addAttribute("areaAdCount", areaAdCount);
		
		Map<Integer, Integer> totalNumberOfRequests = statisticsService.getTotalNumberOfRequests();
		model.addAttribute("totalNumberOfRequests", totalNumberOfRequests);
		List<Map<Integer, Integer>> unitRequestCount = new ArrayList<>();
		for (Unit unit : units) {
			Map<Integer, Integer> count = statisticsService.getTotalRequestsForUnit(unit);
			unitRequestCount.add(count);
		}
		System.out.println(unitRequestCount);
		model.addAttribute("unitRequestCount", unitRequestCount);

		Map<Integer, Integer> totalNumberOfAreaRequests = statisticsService.getTotalNumberOfRequestsWithArea();
		model.addAttribute("totalNumberOfAreaRequests", totalNumberOfAreaRequests);
		List<Map<Integer, Integer>> areaRequestCount = new ArrayList<>();
		for (Area area : areas) {
			Map<Integer, Integer> count = statisticsService.getTotalRequestsForArea(area);
			areaRequestCount.add(count);
		}
		model.addAttribute("areaRequestCount", areaRequestCount);

		Map<Integer, Integer> totalNumberOfBookedAds = statisticsService.getTotalNumberOfBookedAds();
		model.addAttribute("totalNumberOfBookedAds", totalNumberOfBookedAds);
		List<Map<Integer, Integer>> unitBookedCount = new ArrayList<>();
		for (Unit unit : units) {
			Map<Integer, Integer> count = statisticsService.getBookedAdsForUnit(unit);
			unitBookedCount.add(count);
		}
		model.addAttribute("unitBookedCount", unitBookedCount);
		
		Map<Integer, Integer> totalNumberOfBookedAreaAds = statisticsService.getTotalNumberOfBookedAdsWithArea();
		model.addAttribute("totalNumberOfBookedAreaAds", totalNumberOfBookedAreaAds);
		List<Map<Integer, Integer>> areaBookedCount = new ArrayList<>();
		for (Area area : areas) {
			Map<Integer, Integer> count = statisticsService.getBookedAdsForArea(area);
			areaBookedCount.add(count);
		}
		model.addAttribute("areaBookedCount", areaBookedCount);

		model.addAttribute("totalNumberOfExpiredAds", statisticsService.getTotalNumberOfExpiredAds());
		return "config/statistics";
	}
}
