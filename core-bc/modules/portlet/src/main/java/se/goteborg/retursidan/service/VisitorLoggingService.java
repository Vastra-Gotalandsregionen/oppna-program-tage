package se.goteborg.retursidan.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import se.goteborg.retursidan.dao.VisitDAO;
import se.goteborg.retursidan.model.entity.Visit;

import java.util.List;

@Service
@Transactional(propagation = Propagation.REQUIRES_NEW)
public class VisitorLoggingService {
    Logger logger = LoggerFactory.getLogger(this.getClass().getName());

	@Autowired
	private VisitDAO visitDAO;

	@Autowired
	private MailService mailService;
	
	public void logVisit(String uid) {
		logger.debug("Logging visit for user " + uid);
		Visit visit = visitDAO.findByUid(uid);
		
		if (visit != null) {
			visit.setVisitCount(visit.getVisitCount() + 1);
		} else {
			visit = new Visit();
			visit.setUserId(uid);
			visit.setVisitCount(1);
		}
		visit.setUserId(uid);
		visitDAO.saveOrUpdate(visit);

		List<Visit> allByUid = visitDAO.findAllByUid(uid);
		if (allByUid != null && allByUid.size() > 1) {
			mailService.sendMail(new String[]{"patrik.bjork@vgregion.se"}, "tage@vgregion.se", "Varning - Dubbelt i " +
					"besöksloggen i Tage", uid);
		}
	}
	
	public int getUniqueVisitors() {
		return visitDAO.getUniqueVisitorCount();
	}
}