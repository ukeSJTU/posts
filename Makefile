# Git hooks 管理 Makefile

# 定义目录
SCRIPTS_DIR := .scripts
HOOKS_DIR := .git/hooks

# 默认目标
.PHONY: help
help:
	@echo "Git 钩子管理工具"
	@echo ""
	@echo "可用命令:"
	@echo "  make link    - 将 .scripts 目录下的钩子脚本链接到 .git/hooks"
	@echo "  make unlink  - 移除 .git/hooks 中的链接"
	@echo "  make status  - 显示当前钩子状态"
	@echo "  make check   - 检查钩子脚本是否存在并可执行"

# 链接钩子
.PHONY: link
link:
	@echo "链接 Git 钩子..."
	@mkdir -p $(HOOKS_DIR)
	@for hook in $$(ls -1 $(SCRIPTS_DIR) 2>/dev/null); do \
		if [ -f "$(SCRIPTS_DIR)/$$hook" ]; then \
			echo "链接: $$hook"; \
			ln -sf ../../$(SCRIPTS_DIR)/$$hook $(HOOKS_DIR)/$$hook; \
			chmod +x $(SCRIPTS_DIR)/$$hook; \
		fi; \
	done
	@echo "完成！"

# 移除链接
.PHONY: unlink
unlink:
	@echo "移除 Git 钩子链接..."
	@for hook in $$(ls -1 $(SCRIPTS_DIR) 2>/dev/null); do \
		if [ -L "$(HOOKS_DIR)/$$hook" ]; then \
			echo "移除: $$hook"; \
			rm -f $(HOOKS_DIR)/$$hook; \
		fi; \
	done
	@echo "完成！"

# 检查钩子状态
.PHONY: status
status:
	@echo "Git 钩子状态:"
	@if [ ! -d "$(SCRIPTS_DIR)" ]; then \
		echo "警告: $(SCRIPTS_DIR) 目录不存在"; \
		exit 1; \
	fi
	@for hook in $$(ls -1 $(SCRIPTS_DIR) 2>/dev/null); do \
		if [ -L "$(HOOKS_DIR)/$$hook" ]; then \
			echo "$$hook: 已链接 -> $$(readlink $(HOOKS_DIR)/$$hook)"; \
		elif [ -f "$(HOOKS_DIR)/$$hook" ]; then \
			echo "$$hook: 存在 (非链接)"; \
		else \
			echo "$$hook: 未安装"; \
		fi; \
	done
	@# 检查是否有其他钩子存在但不在 .scripts 目录中
	@for hook in $$(ls -1 $(HOOKS_DIR) 2>/dev/null); do \
		if [ ! -f "$(SCRIPTS_DIR)/$$hook" ] && [ -f "$(HOOKS_DIR)/$$hook" ]; then \
			echo "$$hook: 存在于 .git/hooks 但不在 .scripts 目录中"; \
		fi; \
	done

# 检查钩子脚本
.PHONY: check
check:
	@echo "检查 Git 钩子脚本..."
	@if [ ! -d "$(SCRIPTS_DIR)" ]; then \
		echo "警告: $(SCRIPTS_DIR) 目录不存在"; \
		mkdir -p $(SCRIPTS_DIR); \
		echo "已创建 $(SCRIPTS_DIR) 目录"; \
	fi
	@if [ -z "$$(ls -A $(SCRIPTS_DIR) 2>/dev/null)" ]; then \
		echo "警告: $(SCRIPTS_DIR) 目录为空"; \
	else \
		for hook in $$(ls -1 $(SCRIPTS_DIR) 2>/dev/null); do \
			if [ -f "$(SCRIPTS_DIR)/$$hook" ]; then \
				if [ -x "$(SCRIPTS_DIR)/$$hook" ]; then \
					echo "$$hook: 存在且可执行 ✓"; \
				else \
					echo "$$hook: 存在但不可执行 ✗"; \
					chmod +x $(SCRIPTS_DIR)/$$hook; \
					echo "  已添加执行权限 ✓"; \
				fi; \
			fi; \
		done; \
	fi
