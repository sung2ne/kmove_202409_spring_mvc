package com.example.spring.user;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/users")
public class UserController {
    
    @Autowired
    UserService userService;

    // 사용자 목록 (화면, GET)
    @GetMapping("")
    public String listGet(
        @RequestParam(value = "page", defaultValue = "1") int currentPage, 
        @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
        @RequestParam(value = "searchType", required = false) String searchType,
        Model model
    ) {
        int listCountPerPage = 10;  // 한 페이지에서 불러올 사용자 수
        int pageCountPerPage = 5;   // 한 페이지에서 보여질 페이지 수
        Map<String, Object> result = userService.list(currentPage, listCountPerPage, pageCountPerPage, searchType, searchKeyword);
        model.addAttribute("users", result.get("users"));
        model.addAttribute("pagination", result.get("pagination"));
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("searchType", searchType);
        return "user/list";
    }

    // 사용자 보기 (화면, GET)
    @GetMapping("/{userId}")
    public String readGet(@PathVariable("userId") String userId, Model model) {
        // 조회에 사용되는 DTO
        UserDto user = new UserDto();
        user.setUserId(userId);

        // 사용자 정보 조회
        UserDto existsUser = userService.read(user);
        model.addAttribute("user", existsUser);
        return "user/read";
    }

    // 사용자 삭제 (처리, POST)
    @PostMapping("/{userId}/delete")
    public String deleteUser(@PathVariable String userId, UserDto user, RedirectAttributes redirectAttributes) {
        user.setUserId(userId);
        boolean deleted = userService.delete(user);

        // 사용자 삭제 성공
        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "사용자이 삭제되었습니다.");
            return "redirect:/users/";
        }

        // 사용자 삭제 실패
        redirectAttributes.addFlashAttribute("errorMessage", "사용자 삭제에 실패했습니다.");
        return "redirect:/users/" + userId;
    }
}
