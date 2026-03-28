<script setup lang="ts">
import { ref } from 'vue';
import { onClickOutside } from '@vueuse/core';

const props = withDefaults(defineProps<{
  show: boolean,
  shake?: boolean
}>(), { shake: false })

const emits = defineEmits<{
  close: []
  ok: []
}>()

const onOk = () => {
  emits("ok");
}

const onClose = () => {
  emits("close");
}

const target = ref<HTMLElement | null>(null);
onClickOutside(target, () => {
  onClose();
})

</script>

<template>
  <Transition name="modal">
    <div v-if="show" class="modal">
      <div ref="target" :class="['modal__container', { 'modal__container--vibration': props.shake }]">

        <div class="modal__header">
          <slot name="header">
            <span class="noto-sans-extrabold">알림</span>
          </slot>
        </div>

        <div class="modal__body">
          <slot name="body">
            <div>default body</div>
          </slot>
        </div>

        <div class="modal__hr">
          <hr>
        </div>

        <div class="modal__footer">
          <slot name="footer"></slot>
        </div>
      </div>
    </div>
  </Transition>
</template>

<style scoped lang="scss">
@use "@/common/asset/css/global" as *;

.modal {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  transition: opacity 0.3s ease;
  overflow-y: auto;
}

.modal__container {
  width: 280px;
  margin: auto;
  padding: 20px;
  background-color: $white;
  border-radius: 15px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
  transition: all 0.3s ease;
}

.modal__header {
  text-align: center;
  margin-bottom: 20px;
  font-size: font-size(lg);
}

.modal__body {
  text-align: center;
  font-size: font-size(md);
  display: flex;
  justify-content: center;
  row-gap: 20px;
  flex-direction: column;
  margin-bottom: 10px;
}

.modal__hr hr {
  border: none; // 기본 테두리 제거
  border-top: 1px solid $black; // 원하는 색과 두께 지정
  margin: 0; // 필요에 따라 여백 조정
}

/*
 * The following styles are auto-applied to elements with
 * transition="modal" when their visibility is toggled
 * by Vue.js.
 *
 * You can easily play with the modal transition by editing
 * these styles.
 */

.modal-enter-from {
  opacity: 0;
}

.modal-leave-to {
  opacity: 0;
}

.modal-enter-from .modal__container,
.modal-leave-to .modal__container {
  -webkit-transform: scale(1.1);
  transform: scale(1.1);
}


.modal__container--vibration {
  animation: vibration 0.1s infinite;

  /* 빠르게 무한 반복 */
}

/* 잘못된 걸 눌렀을 때 진동효과 */
@keyframes vibration {

  0%,
  100% {
    transform: translateX(0);
  }

  20% {
    transform: translateX(-2px);
  }

  40% {
    transform: translateX(2px);
  }

  60% {
    transform: translateX(-2px);
  }

  80% {
    transform: translateX(2px);
  }
}
</style>